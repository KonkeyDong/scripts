#!/usr/bin/ruby

class Utilities
  def self.prompt(phrase)
    puts "#{phrase.strip} (y/n)"

    while(true)
      str = STDIN.getc
      return true  if str =~ /^y$/i
      return false if str =~ /^n$/i
    end
  end
end

