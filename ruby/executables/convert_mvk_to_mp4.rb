require 'debug'
require 'fileutils'
require 'optparse'
require 'shellwords'

if ARGV.length < 1
  puts "Please supply a list of files (Ex: ls *.mkv)"
  exit 1
end

trash_path = "/media/HDD_16TB_01/videos/holding_place"

def help
  message = %Q(
    Convert containers to MP4 with H264 video codec and AAC audio codec.
    Sets the "Web-Optimized" flag on all conversions.

    -h, --help: Print this help message and exit successfully.
    --h264    : Convert video codecs to h264. Copies video codec by default.
    --aac     : Convert audio codecs to AAC. Copies audio codec by default.
  )
  puts message
end

options = {
    aac: false,
    h264: false,
    debug: false
}

OptionParser.new do |opts|
    opts.on('-h', '--help') do
        help
        exit 0
    end

    opts.on('--h264') do
        options[:h264] = true
    end

    opts.on('--aac') do
        options[:aac] = true
    end

    opts.on('--debug') do
        options[:debug] = true
    end

end.parse!

# CAUTION: this may be slow to convert
def h264_flag(flag)
  flag ? "-c:v libx264" : "-c:v copy"
end

def aac_flag(flag)
  flag ? "-c:a aac" : "-c:a copy"
end

def build_output_path(input_path)
  input_ext = File.extname(input_path)
input_path.sub(input_ext, ".mp4")
end

# Read files supplied from command line (ls *.mkv)
ARGV.each_with_index do |file, index|
  index += 1
  file = file.chomp
  next if file == ""

  # Remove annoying quotes to make renaming and running system commands easier
  new_file_name = file.gsub("'", "")
                 .gsub(/"/, "")
                 .gsub("&", "and")

  # the mv command will fail if the two names are the same.
  FileUtils.mv(file, new_file_name) if !options[:debug] && file != new_file_name

  # get full paths
  input_path = File.absolute_path(new_file_name)
  output_path = build_output_path(input_path)
  dir_name = File.dirname(input_path).split("/").last

  # go up one more directory if the deepest directory contains "season"
  if dir_name =~ /season/i
    dir_name = File.dirname(input_path).split("/")[-2]
  end

  # create the folder at the trash path
  new_dest = "#{trash_path}/#{dir_name}/."
  FileUtils.mkdir_p(new_dest) unless options[:debug]

  puts ""
  puts "Now converting #{input_path} (#{index} / #{ARGV.length})"
  puts ""

  command = [
    "nice -n 19",
    "ffmpeg -i '#{input_path}'",
    h264_flag(options[:h264]),
    aac_flag(options[:aac]),
    "-movflags faststart",
    "'#{output_path}'"
  ].join(" ")

  if options[:debug]
    puts "DEBUG: system command is: #{command}"
    puts "Program will stop without running system command..."
    exit 0
  else
    system("#{command}") unless options[:debug]

    # $? is the Global Variable for Exit Status Code.
    # Should be either true, false, or nil.
    if $?
      puts ""
      puts "Finished! moving to: #{new_dest}..."
      puts ""

      FileUtils.mv(input_path, new_dest)
    end
  end
end

puts "finished!"

