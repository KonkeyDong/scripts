require 'debug'
require 'fileutils'
require 'optparse'
require 'shellwords'

if ARGV.length < 1
  puts "Please supply a list of files (Ex: ls *.mkv)"
  exit 1
end

trash_path = "/media/HDD_16TB_01/videos/holding_place"


options = {
    aac: false
}

OptionParser.new do |opts|
    opts.on('-h', '--help') do
        help
        exit 0
    end

    opts.on('--aac') do
        options[:aac] = true
    end

end.parse!

def aac_flag(flag)
  flag ? "-c:a aac" : "-c:a copy"
end

ARGV.each do |file|
  file = file.chomp
  next if file == ""

  # Remove annoying quotes to make renaming and running system commands easier
  new_file_name = file.gsub("'", "")
                 .gsub(/"/, "")

  # the mv command will fail if the two names are the same.
  FileUtils.mv(file, new_file_name) unless file == new_file_name

  # get full paths
  input_path = File.absolute_path(new_file_name)
  output_path = input_path.sub(".mkv", ".mp4")
  dir_name = File.dirname(input_path).split("/").last

  # go up one more directory if the deepest directory contains "season"
  if dir_name =~ /season/i
    dir_name = File.dirname(input_path).split("/")[-2]
  end

  # create the folder at the trash path
  new_dest = "#{trash_path}/#{dir_name}/."
  FileUtils.mkdir_p(new_dest)

  puts "Now converting #{input_path}..."

  command = [
    "nice -n 19",
    "ffmpeg -i '#{input_path}'",
    "-c:v copy",
    aac_flag(options[:aac]),
    "-movflags faststart",
    "'#{output_path}'"
  ].join(" ")

  system("#{command}")

  # $? is the Global Variable for Exit Status Code.
  # Should be either true, false, or nil.
  if $?
    puts "Finished! moving to: #{new_dest}..."
    FileUtils.mv(input_path, new_dest)
  end
end

puts "finished!"

