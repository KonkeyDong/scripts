require 'debug'
require 'fileutils'
require 'optparse'
require 'shellwords'

if ARGV.length < 1
  puts "Please supply a list of files (Ex: ls *.mkv)"
  exit 1
end

trash_path = "/media/HDD_16TB_01/videos/holding_place"
current_file = ""
current_temp_file = ""

trap("SIGINT") do
  puts ""
  puts "An interrupt signal was detected. Reverting temp file and aborting."
  FileUtils.mv(current_temp_file, current_file)
  exit 0
end

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

def get_video_codec(input_path)
  # AVC is H264; HVEC is H265
  command = [
    "mediainfo",
    '--Inform="Video;%Format%"',
    "'#{input_path}'"
  ].join(" ")
  output = `#{command}`
  output.chomp
end

def get_audio_codec(input_path)
  # AAC is what we want
  command = [
    "mediainfo",
    '--Inform="Audio;%Format%"',
    "'#{input_path}'"
  ].join(" ")
  output = `#{command}`
  output.chomp
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
  input_path_temp = "#{input_path}.temp"
  output_path = build_output_path(input_path)
  dir_name = File.dirname(input_path).split("/").last

  # Set current and temp file in the evenet of a sig interrupt
  current_file = input_path
  current_temp_file = input_path_temp

  # go up one more directory if the deepest directory contains "season"
  if dir_name =~ /season/i
    dir_name = File.dirname(input_path).split("/")[-2]
  end

  video_codec = get_video_codec(input_path)
  audio_codec = get_audio_codec(input_path)

  puts "Video Codec: #{video_codec}"
  puts "Audio Codec: #{audio_codec}"

  unless video_codec.upcase == "AVC"
    puts "Video codec is not AVC (H264) and will take too long to process."
    exit 1
  end

  unless audio_codec.upcase == "AAC"
    puts "Audio codec is not AAC; setting --aac flag to true"
    options[:aac] = true
  end

  # allow converting files from .mp4 to .mp4 without failing
  unless options[:debug]
    FileUtils.mv(input_path, input_path_temp)
  end

  # create the folder at the trash path
  new_dest = "#{trash_path}/#{dir_name}/."
  FileUtils.mkdir_p(new_dest) unless options[:debug]

  puts ""
  puts "Now converting #{input_path} (#{index} / #{ARGV.length})"
  puts ""

  command = [
    "nice -n 19",
    "ffmpeg -i '#{input_path_temp}'",
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

      FileUtils.mv(input_path_temp, new_dest)
    end
  end
end

puts "finished!"

