require 'byebug'
require 'forkmanager'
require_relative '../Classes/utilities'
require_relative '../Classes/traverse'


# TODO: add cmd options for num_threads

directory = ARGV
directory = Dir.getwd if directory.empty?

puts "directory: #{directory}"
exit 0 unless Utilities::prompt("Do you want to shred everything in the directory [#{directory}]?")

traverse = Traverse.new(directory)

pm = Parallel::ForkManager.new(4) # 4 = max procs
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