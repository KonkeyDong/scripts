#!/usr/bin/ruby

class Utilities
  @files = []
  @directories = []

  def self.prompt(phrase)
    puts "#{phrase.strip} (y/n)"

    while(true)
      str = STDIN.getc
      return true  if str =~ /^y$/i
      return false if str =~ /^n$/i
    end
  end

  def self.get_directory_contents(directory)
    Dir.entries(directory)
       .reject { |file| file =~ /^\.{1,2}$/ }
       .map { |file| File.realpath(file) }
  rescue SystemCallError => e
    STDERR.puts e
    STDERR.puts "Dir path: #{directory}"
    exit 1
  end

  def self.build_tree_contents(directory)
    directory = File.realpath(directory)

    # reset
    @files = []
    @directories = []

    build_tree_contents_helper(directory)
    return nil
  end

  def self.files
    @files
  end

  def self.directories
    @directories
  end

  private

  def self.build_tree_contents_helper(directory)
    Dir.chdir(directory)

    get_directory_contents(directory).each do |file|
      if (File.directory?(file))
        @directories.unshift(file)
        build_tree_contents_helper(file)
        Dir.chdir(directory)
      end

      @files.push(file) if File.file?(file)
    end
  end
end

