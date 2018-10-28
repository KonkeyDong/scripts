
require 'byebug'
require 'nokogiri'
require 'ap'
require 'open-uri'
require 'fileutils'

class Scrape
  attr_accessor :album, :number_of_songs, :bad_songs

  def initialize(url)
    @url = url
    @html = Nokogiri::HTML(open(@url))
    @album = get_album_name
    @number_of_songs = get_number_of_songs.to_i
    @songlist = @html.xpath('//table[@id="songlist"]/tr/td[@class="clickable-row"]')
    @header_length = get_header_length
    @bad_songs = false
  end

  def download
    return if check_number_of_songs_found
    FileUtils.mkdir_p @album
    i = 1
    pre_download.each do |data|
      puts "Now downloading: [#{data[:title]} (#{i} of #{@number_of_songs})]"
      i += 1 # ruby doesn't like i++...
      file_url = Nokogiri::HTML(open(data[:url])).xpath('//audio').first.attributes["src"].value
      IO.copy_stream(open(file_url), "./#{@album}/#{data[:title]}")
    end
  end

  private

  def pre_download
    data = []
    for i in 0...@songlist.length do
      next if @songlist[i].text =~ /\d+:\d+/ # song length
      next if @songlist[i].text =~ /\d+\.\d+\s[MK]B/i # song size

      data.push(
        {
          title: @songlist[i].text,
          url: "https://downloads.khinsider.com#{@songlist[i].children.first.attributes["href"].value}"
        }
      )
    end

    return data
  end

  def check_number_of_songs_found
    return nil if (@songlist.length / @header_length) == @number_of_songs

    STDERR.puts 'Number of songs mismatch!'
    STDERR.puts "@album: #{@album}"
    STDERR.puts "@number_of_songs: #{@number_of_songs}"
    STDERR.puts "found: #{@songlist.length / @header_length}"
    STDERR.puts "Ignoring..."
    # error_buffer.push(@url)
    @bad_songs = true
  end

  def extract_data(regex)
    @html.xpath('//p[@align="left"]')
         .first
         .to_s
         .match(regex)
         .captures
         .first
  end

  def get_album_name
    extract_data(album_regex)
  end

  def get_number_of_songs
    extract_data(number_of_songs_regex)
  end

  def get_header_length
    @html.xpath('//tr[@id="songlist_header"]').xpath('//th').length / 2
  end

  def number_of_songs_regex
    Regexp.new('number of files: <b>(\d+)</b>', Regexp::IGNORECASE)
  end

  def album_regex
    Regexp.new("album name: <b>(.+)</b>", Regexp::IGNORECASE)
  end

end

error_buffer = []
file_name = "url_list.txt"

File.open(file_name, 'r') do |file|
  file.each do |line|
    line = line.chomp
    puts
    puts "Now downloading: [#{line}]"
    data = Scrape.new(line)
    data.download

    error_buffer.push(line) if data.bad_songs
  end
end

IO.write(file_name, error_buffer.join("\n")) if error_buffer
puts 'Complete!'