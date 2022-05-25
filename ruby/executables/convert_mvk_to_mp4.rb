require 'fileutils'

if ARGV.length < 1
  puts "Please supply a list of files (Ex: ls *.mkv)"
  exit 1
end

trash_path = "/media/HDD_16TB_01/videos/holding_place/."

ARGV.each do |file|
  input_path = File.absolute_path(file).chomp
  output_path = input_path.sub(".mkv", ".mp4")

  command = [
    "ffmpeg -i '#{input_path}'",
    "-c:v copy",
    "-c:a copy",
    "-movflags faststart",
    "'#{output_path}'"
  ].join(" ")

  #puts command

  system("#{command}")

  FileUtils.mv(input_path, trash_path)
end

puts "finished!"

