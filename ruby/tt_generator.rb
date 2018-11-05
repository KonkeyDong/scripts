require 'byebug'
require 'ap'

def generate(x)
    pow = 2 ** x.length - 1

    i = 0
    coll = []
    (0..pow).each do |_|
        coll.push(i.to_s(2).rjust(x.length, '0'))
        i += 1
    end

    coll
end

x = generate([1, 2, 3, 4])
byebug
puts 'hi'
