require 'byebug'
require 'forkmanager'
require 'getoptlong'
require_relative '../Classes/utilities'
require_relative '../Classes/traverse'

options = {
    num_threads: 4
}

getopts = GetoptLong.new(
    [ '--num-threads', GetoptLong::OPTIONAL_ARGUMENT ],
    [ '--help', '-h', GetoptLong::OPTIONAL_ARGUMENT ]
)

getopts.each do |opt, arg|
    case opt
    when '--num-threads'
        options[:num_threads] = arg.to_i
        puts "--num-threads set to [#{options[:num_threads]}]"
        STDERR.puts "WARNING: over-threading can lower performance, especially on HDDs. Use at your own risk..." if options[:num_threads] > 4
    when '--help', '-h'
        puts <<~HEREDOC
        --- COMMAND LINE ARGS ---
            --num-threads n
                Sets the numbers of threads n for parallel execution.
                Defaults to 4.
                Warning: avoid using many threads on HDDs.
    
            --help
                Display this help doc and exit.
        HEREDOC
        exit 0
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

    # TODO: maybe make a simple shred utility in ruby? Not sure;
    # the C code looks sophisticated, but it would add portability.
    %x(/usr/bin/shred -uz "#{file}")

    pm.finish(0)
end
pm.wait_all_children

puts "Removing directories..."
traverse.directories.each { |directory| Dir.rmdir(directory) }

exit 0
