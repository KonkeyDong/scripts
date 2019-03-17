require 'byebug'
require 'fileutils'
require 'ap'
require_relative '../classes/KHInsider'

def exit_error
    STDERR.puts "Missing a file path for the first argument! Aborting..."
    exit
end

error_buffer = []
exit_error if ARGV.length != 1

file_name = ARGV.shift

File.open(file_name, 'r') do |file|
  file.each do |line|
    line = line.chomp
    puts
    puts "Now downloading: [#{line}]"
    data = KHInsider.new(line)
    data.download

    error_buffer.push(line) if data.bad_songs
  end
end

IO.write(file_name, error_buffer.join("\n")) if error_buffer
puts 'Complete!'
