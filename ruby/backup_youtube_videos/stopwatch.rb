#!/usr/bin/ruby

class Stopwatch

  def initialize()
    @start = Time.now
  end

  def elapsed_time
    now = Time.now
    elapsed = now - @start
    puts 'Started: ' + @start.to_s
    puts 'Now: ' + now.to_s
    #puts 'Elapsed time: ' +  elapsed.to_s + ' seconds'
    result = {
        decimal: 0,
        seconds: 0,
        minutes: 0,
        hours:   0,
        days:    0,
    }

    result[:decimal] = ((elapsed - elapsed.truncate) * 1000).truncate
    elapsed = elapsed.truncate


    if (elapsed > 60)
        result[:seconds] = elapsed % 60
        elapsed = elapsed / 60
    end

    if (elapsed > 60)
        result[:minutes] = elapsed % 60
        elapsed = elapsed / 60
    end

    if (elapsed > 24)
        result[:hours] = elapsed % 24
        result[:days] = elapsed / 24
    end

    puts "Elapsed time: #{result[:days]} days, #{result[:hours]}H #{result[:minutes]}M #{result[:seconds]}.#{result[:decimal]}S"
  end
end

