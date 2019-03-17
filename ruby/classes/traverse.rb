#!/usr/bin/ruby

class Traverse 
  attr_reader :files, :directories

  def initialize(directory = nil)
    traverse_directories(directory) if directory
  end

  # get directory contents without "." and ".." (non-recursive)
  def get_directory_contents(directory)
    exists?(directory)

    Dir.entries(directory)
       .reject { |file| file =~ /^\.{1,2}$/ }
       .map { |file| File.realpath(file) }
  rescue SystemCallError => e
    bad_directory(e)
  end

  def traverse_directories(directory)
    exists?(directory)

    directory = File.realpath(directory)

    # reset
    @files = []
    @directories = []

    traverse_directories_helper(directory)
    return nil
  rescue SystemCallError => e
    bad_directory(e)
  end

  private

  def traverse_directories_helper(directory)
    Dir.chdir(directory)

    get_directory_contents(directory).each do |file|
      if (File.directory?(file))
        @directories.unshift(file)
        traverse_directories_helper(file)
        Dir.chdir(directory)
      end

      @files.push(file) if File.file?(file)
    end
  end

  def exists?(directory)
    raise SystemCallError "Bad directory: #{directory}" unless File.directory?(directory)
  rescue SystemCallError => e
    STDERR.puts e
    STDERR.puts "Dir path: #{directory}"
    exit 1
  end
end

