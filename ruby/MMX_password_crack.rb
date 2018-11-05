

class MMXPasswordCrack

    attr_accessor :cp, :se, :fm, :sm, :aa, :lo, :bk, :sc,
        :cp_ht, :se_ht, :fm_ht, :sm_ht, :aa_ht, :lo_ht, :bk_ht, :sc_ht,
        :se_st, :fm_st, :sm_st, :aa_st, :x_buster, :helmet, :armor, :boots

    # set defaults on bosses alive / items collected.
    # false = boss is alive / item NOT collected.
    # true  = boss is dead / item collected.
    def initialize
        bosses
        heart_tanks
        sub_tanks
        suit_parts
    end

    def bosses
        cp = false # Chill Penguin
        se = false # Storm Eagle
        fm = false # Flame Mammoth
        sm = false # Spark Mandrill

        aa = false # Armored Armadillo
        lo = false # Launch Octopus
        bk = false # Boomer Kuwanger
        sc = false # Sting Chameleon
    end

    def heart_tanks # = HT
        cp_ht = false
        se_ht = false
        fm_ht = false
        sm_ht = false

        aa_ht = false
        lo_ht = false
        bk_ht = false
        sc_ht = false
    end

    def sub_tanks # = ST
        se_st = false
        fm_st = false
        sm_st = false
        aa_st = false
    end

    def suit_parts
        x_buster = false
        helmet = false
        armor = false
        boots = false
    end

    # Password screen looks like below. Each cell can be a number from 1..8
    # 1234
    # 5678
    # 9ABC

    # First number = row
    # Second number = column
    # Looking at the chart above:
    # P1_1 = 1
    # P2_3 = 7
    # P3_4 = C
    # etc...

    # If the result is an array, count the number of trues in the "other" factor.
    # If even, pick the left number. If odd, pick the right number.
    def P1_1
        code = {
            N: [4, 1],
            X: [2, 7],
            Y: [6, 5],
            XY: [8, 3]
        }

        value = code[find_factor(cp_ht, aa_st)]

        return value if number?(value)
        other_factor(value, [cp, fm, lo_ht, sc_ht, sm_st, se_st, helmet, armor, x_buster])
    end 

    # Factors:
    # N: = neither X or Y are true
    # X: = only X is true
    # Y: = only Y is true
    # XY = both X and Y are true
    def find_factor(x, y)
        return :N if !x && !y
        return :X if x && !y
        return :Y if !x && y
        return :XY
    end

    def other_factor(value, list)
        return value[0] if event_number_of_trues?(list)
        return value[1]
    end

    def number?(number)
        number.is_a(Numeric)
    end

    def event_number_of_trues?(list)
        list.count { |item| item }.even?
    end
end
