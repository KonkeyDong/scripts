#!/usr/bin/ruby

require 'byebug'
require 'fileutils'
require 'pp'
require 'optparse'
require_relative './stopwatch'
require_relative './data'
require_relative './config'

def build_file_destination_path(path, directory_name)
    "#{Config::HDD_DESTINATION_BASE}/#{path}/#{directory_name}"
end

# Note: data is an array of arrays. See data.rb for details on the information.
def download(data, format, path, options)

    data.each do |(url, directory_name)|
        #puts "url: #{url} | directory_name: #{directory_name}"

        full_path = build_file_destination_path(path, directory_name)

        #FileUtils.makedirs full_path
        system([
            Config::YOUTUBE_DL_BASE,
            "--format #{format}",
            "'#{url}'",
            "-o '#{full_path}/%(upload_date)s_%(title)s.%(ext)s'",
            options[:number_of_downloads],
            options[:download_speed],
            "--restrict-filenames",
            options[:cookie],
             "--download-archive #{full_path}/archive.txt"
        ].join(' '))
    end
end

def build_hash_structure_for_download(data, format, path)
    data.reduce({}) do |previous, (url, author)|
        previous[author.to_sym] = {
            url: url,
            format: format,
            path: path
        }

        previous
    end
end

def select_specific_download(audio, video, options)
    selection = prompt_choices(audio, video)
    exit_program?(selection)

    selection.each do |item|
        result = {
            **build_hash_structure_for_download(audio, 'bestaudio', 'audio'),
            **build_hash_structure_for_download(video, 'bestvideo', 'videos')
        }[item.to_sym]

        data_format = [[result[:url], item]]
        download(data_format, result[:format], result[:path], options)
    end
    rescue => e
        puts e.message
        exit 1
end

def prompt_choices(audio, video)
    puts "Pick a number to select which yotube playlist to download:"
    prompt = [*audio, *video].reduce(['EXIT PROGRAM']) do |previous, (url, author)|
        previous.push(author)

        previous
    end

    prompt.each_with_index do |author, index|
        puts "#{index.to_s.rjust(3, ' ')}: #{author}"
    end

    gets
        .chomp
        .gsub(/\s+/, " ")
        .split(" ")
        .map(&:to_i)
        .reduce([]) do |previous, current|
            previous.push(prompt[current])

            previous
        end
end

def exit_program?(selection)
    if selection.nil? || selection == 'EXIT PROGRAM'
        puts "EXIT PROGRAM or invalid selection selected. Aborting..."
        exit 0
    end

    false
end

def help
    heredoc = <<-HEREDOC
    backup_youtube_videos.rb manual pages:

        -c, --cookie cookie_file.txt       : Set the youtube cookie. Don't use ~ in your path!
        -h, --help                         : Print the help docs and exit.
        -n, --number-of-downloads <number> : Set the MAX number of downloads.
        -s, --select                       : Select a specific url to download its entire library.
                                                Exit upon completion.
        -u, --no-download-speed-throttle   : Removes the default 1 MB/second throttle.
                                                (Careful not to get banned!!)
    HEREDOC

    puts heredoc
end

options = {
    number_of_downloads: '',
    cookie: '',
    download_speed: '-r 1m', # 1 MB download/second MAX default
    select_download: false
}

OptionParser.new do |opts|
    opts.on('-h', '--help') do
        help
        exit 0
    end

    opts.on('-nSTRING' || '-n STRING', '--number-of-downloads STRING' || '--number-of-downloads=STRING') do |number|
        options[:number_of_downloads] = "--max-downloads #{number}"
        puts "Number of MAX downloads set to #{number}"
    end

    opts.on('-u', '--no-download-speed-throttle') do
        options[:download_speed] = ''
        puts "Download speed NOT throttled"
    end

    opts.on('-c STRING', '--cookies STRING') do |cookie_file|
        options[:cookie] = "--cookie #{File.absolute_path(cookie_file)}"
        puts "cookie: #{options[:cookie]}"
    end

    opts.on('-s', '--select') do
        options[:select_download] = true
    end

end.parse!

s = Stopwatch.new
if options[:select_download]
    select_specific_download(AUDIO, VIDEO, options)
else
    download(AUDIO, 'bestaudio', 'audio', options)
    download(VIDEO, 'bestvideo', 'videos', options)
end
s.elapsed_time
