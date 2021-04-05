require 'byebug'
require 'fileutils'
require 'ap'
require 'open-uri'
require 'nokogiri'

require_relative './url_data'

BASE_DIRECTORY_PATH = '/media/HDD_4TB_01/manga'
READ_TIMEOUT = 30 # in seconds

def pre_download(url)
    html = Nokogiri::HTML(open(url, read_timeout: READ_TIMEOUT))
    html.css('.chapter-name.short')
        .reverse
        .each_with_index
        .map do |chapter, index|
             data = chapter.css('a')
                           .first

             {
                 title: ["chapter", (index + 1).to_s
                                               .rjust(4, "0")]
                                               .join('_'),
                 href: data["href"]
             }
        end
end

def download(chapters_and_href, book_name, archive, archive_hash)
    chapters_and_href.each do |data|
        STDOUT.flush
        title = data[:title]
        href = data[:href]

        directory = [BASE_DIRECTORY_PATH, book_name, title].join("/")
        FileUtils.mkdir_p(directory)

        puts "Downloading book #{book_name}, chapter #{title}..."
        html = Nokogiri::HTML(open(href, read_timeout: READ_TIMEOUT))
                       .css('.sl-page option')

        # The website doubles the amount of chapter pages in the source code for some reason.
        # So, only take from thef irst half to avoid doubling the amount of pages in the directory.
        html[0...(html.length / 2)].each_with_index do |page, index|
            page_url = page["value"]

            if archive_hash[page_url]
                name = (index + 1).to_s.rjust(4, "0") + ".image"
                puts "Skipping [#{name}] as it has already been downloaded."
                next
            end

            image_url = Nokogiri::HTML(open(page_url, read_timeout: READ_TIMEOUT))
                                .css('.manga_pic')
                                .first["src"]

            file_extension = image_url.match(/\.(\w+)$/)
                                      .captures
                                      .first
                                      .downcase

            file_name = (index + 1).to_s.rjust(3, "0") + ".#{file_extension}"

            # write image file
            # puts "#{directory}/#{file_name} | #{image_url}"
            open(image_url) do |image|
                File.open("#{directory}/#{file_name}", "wb") do |file|
                    file.write(image.read)
                end
            end

            # update the archive file
            File.write(archive, "#{page_url}\n", mode: 'a')
        end
    end
end

URL_DATA.each do |(url, book_name)|
    puts "Now downloading [#{book_name}]..."
    chapters_and_href = pre_download(url)

    directory = [BASE_DIRECTORY_PATH, book_name].join("/")
    FileUtils.mkdir_p(directory)

    # look through archive to avoid unnecessary rewrites.
    archive = [directory, "archive.txt"].join("/")
    FileUtils.touch(archive) # create file if it doesn't exist
    archive_hash = File.open(archive)
                       .readlines
                       .map(&:chomp)
                       .map { |url| [url, true] }.to_h

    download(chapters_and_href, book_name, archive,  archive_hash)

    # prevent output hanging after sufficient output messages.
    STDOUT.flush
end

puts "Complete!"

