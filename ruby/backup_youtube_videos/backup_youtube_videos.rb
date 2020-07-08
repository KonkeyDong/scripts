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
        command = [
            Config::YOUTUBE_DL_BASE,
            "--format #{format}",
            "'#{url}'",
            "-o '#{full_path}/#{Config::DESIRED_FILE_FORMAT}'",
            "#{options[:number_of_downloads]}", 
            "#{options[:download_speed]}",
            "--restrict-filenames",
            "--cookies ./cookies.txt"
        ].join(' ')

        system("#{command}")
    end
end

def build_hash_structure_for_download(data, format, path)
    data.reduce({}) do |previous, (url, author)|
        new_author = author.to_sym
        previous[new_author] = {}
        previous[new_author][:url] = url
        previous[new_author][:format] = format
        previous[new_author][:path] = path

        previous
    end
end

# TODO: Clean this code up!
def select_specific_download(audio, video, options)
    combined_data = {
        **build_hash_structure_for_download(audio, 'bestaudio', 'audio'),
        **build_hash_structure_for_download(video, 'bestvideo', 'videos')
    }

    puts "Pick a number to select which yotube playlist to download:"
    prompt = [*audio, *video].reduce(['EXIT PROGRAM']) do |previous, (url, author)|
        previous.push(author)

        previous
    end

    prompt.each_with_index do |author, index|
        puts "#{index.to_s.rjust(3, ' ')}: #{author}"
    end

    selection = prompt[gets.chomp.to_i]

    if selection.nil? || selection == 'EXIT PROGRAM'
        puts "EXIT PROGRAM or invalid selection selected. Aborting..."
        exit 0
    end

    result = combined_data[selection.to_sym]
    final_result = [[result[:url], selection]]
    download(final_result, result[:format], result[:path], options)

    rescue => e
        puts e.message
        exit 1
end

def help
    heredoc = <<-HEREDOC
    backup_youtube_videos.rb manual pages:

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
    download_speed: '-r 1m', # 1 MB download/second MAX default
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

    opts.on('-s', '--select') do
        s = Stopwatch.new
        select_specific_download(AUDIO, VIDEO, options)
        s.elapsed_time
        exit 0
    end

end.parse!

s = Stopwatch.new
download(AUDIO, 'bestaudio', 'audio', options)
download(VIDEO, 'bestvideo', 'videos', options)
s.elapsed_time

