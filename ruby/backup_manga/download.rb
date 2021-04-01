require 'byebug'
require 'fileutils'
require 'ap'
require 'open-uri'
require 'nokogiri'

require_relative './url_data'

BASE_DIRECTORY_PATH = '/media/HDD_4TB_01/manga'

def exit_error
    STDERR.puts "Missing a file path! Aborting..."
    exit 1
end

def pre_download(url)
    html = Nokogiri::HTML(URI.open(url))
    html.css('.chapter-name.short')
                   .reverse
                   .map do |chapter|
                        data = chapter.css('a').first
                        {
                            title: data.text.downcase.gsub(/\s+/, '_').gsub(/^ch/, 'chapter'),
                            href: data["href"]
                        }
                   end
end

def download(chapters_and_href, book_name)
    chapters_and_href.each do |data|
        title = data[:title]
        href = data[:href]
        
        directory = [BASE_DIRECTORY_PATH, book_name, title].join("/")
        # puts directory
        FileUtils.mkdir_p(directory)

        html = Nokogiri::HTML(URI.open(href)).css('.sl-page option')        
        html[0...(html.length / 2)].each_with_index do |page, index|
            image_url = Nokogiri::HTML(URI.open(page["value"])).css('.manga_pic').first["src"]
            file_extension = image_url.match(/\.(\w+)$/).captures.first.downcase
            file_name = (index + 1).to_s.rjust(3, "0") + ".#{file_extension}"
            
            # write image file
            # puts "#{directory}/#{file_name} | #{image_url}"
            open(image_url) do |image|
                File.open("#{directory}/#{file_name}", "wb") do |file|
                    file.write(image.read)
                end
            end
        end
    end
end

URL_DATA.each do |(url, book_name)|
    puts "Now downloading [#{book_name}]..."
    chapters_and_href = pre_download(url)
    download(chapters_and_href, book_name)
end

puts "Complete!"
