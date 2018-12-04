require 'byebug'
require 'forkmanager'
require 'getoptlong'
require_relative '../Classes/utilities'
require_relative '../Classes/traverse'

# TODO: add cmd options for num_threads
options = {
    num_threads: 4
}

getopts = GetoptLong.new(
    [ '--num-threads', '-n', GetoptLong::OPTIONAL_ARGUMENT ]
)

getopts.each do |opt, arg|
    case opt
    when '--num-threads'
        options[:num_threads] = arg.to_i
        # puts "--num-threads: #{options[:num_threads]}"
        STDERR.puts "WARNING: over-threading can lower performance, especially on HDDs. Use at your own risk..." if options[:num_threads] > 4
    end
end

directory = ARGV
directory = Dir.getwd if directory.empty?

exit 0 unless Utilities::prompt("Do you want to shred everything in the directory [#{directory}]?")

traverse = Traverse.new(directory)

pm = Parallel::ForkManager.new(options[:num_threads])
traverse.files.each do |file|
    pm.start(file) && next

    puts "Shredding file: [#{file}]"
    %x(/usr/bin/shred -uz "#{file}")

    pm.finish(0)
end
pm.wait_all_children

puts "Removing directories..."
traverse.directories.each { |directory| Dir.rmdir(directory) }

exit 0 # success