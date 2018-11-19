
require 'byebug'
require 'nokogiri'
require 'ap'
require 'open-uri'
require 'forkmanager'

class Scrape
  attr_accessor :album, :number_of_songs, :bad_songs

  def initialize(url, add_track_numbers = false)
    @url = url
    @html = Nokogiri::HTML(open(@url))
    @album = get_album_name
    @number_of_songs = get_number_of_songs.to_i
    @songlist = @html.xpath('//table[@id="songlist"]/tr/td[@class="clickable-row"]')
    @bad_songs = false
    @add_track_numbers = add_track_numbers
  end

  def download
    songs = pre_download
    return if check_number_of_songs_found(songs)

    pm = Parallel::ForkManager.new(30) # 30 = max procs

    FileUtils.mkdir_p @album
    songs.each do |data|
      pm.start(data) && next # blocks until new fork slot is available

      puts "Now downloading: [#{data[:title]}] (of #{@number_of_songs})"
      file_url = Nokogiri::HTML(open(data[:url])).xpath('//audio').first.attributes["src"].value
      IO.copy_stream(open(file_url), "./#{@album}/#{data[:title]}")

      pm.finish(0)
    end

    pm.wait_all_children
  end

  private

  def pre_download
    data = []
    for i in 0...@songlist.length do
      next if @songlist[i].text =~ /\d+:\d+/ # song length
      next if @songlist[i].text =~ /\d+\.\d+\s[MK]B/i # song size

      song = @songlist[i].text
              .gsub('[', '(')
              .gsub(']', ')')
              .gsub("'", '')
              .gsub('-', ' ')
              .gsub(/\s+/, '_')
              .gsub(/_$/, '')

      song = "#{song}.mp3" unless song.match(Regexp.new('\.mp3$', Regexp::IGNORECASE))
      data.push(
        {
          title: song,
          url: "https://downloads.khinsider.com#{@songlist[i].children.first.attributes["href"].value}"
        }
      )
    end

    if @add_track_numbers
      data = add_track_numbers(data)
    else
      data = add_track_numbers(data) unless has_track_numbers?(data)
    end

    return data
  end

  def has_track_numbers?(songs)
    samples = songs.shuffle.first(10)
    samples.each do |sample|
      return true if sample[:title].match(Regexp.new('_?\d{2,4}_'))
    end

    false
  end

  def add_track_numbers(songs)
    new_songs = []
    for i in 0...@number_of_songs
      new_songs.push(
        title: "#{(i + 1).to_s.rjust(3, '0')}_#{songs[i][:title]}",
        url: songs[i][:url]
      )
    end
    new_songs
  end

  def check_number_of_songs_found(songs)
    return nil if songs.length == @number_of_songs

    STDERR.puts 'Number of songs mismatch!'
    STDERR.puts "@album: #{@album}"
    STDERR.puts "found: #{@songs.length} out of #{@number_of_songs}"
    STDERR.puts "Ignoring..."
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

  def number_of_songs_regex
    Regexp.new('number of files: <b>(\d+)</b>', Regexp::IGNORECASE)
  end

  def album_regex
    Regexp.new("album name: <b>(.+)</b>", Regexp::IGNORECASE)
  end

end

