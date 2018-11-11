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
        data = {
            N: [4, 1],
            X: [2, 7],
            Y: [6, 5],
            XY: [8, 3],
            factor: {
                X: cp_ht,
                Y: aa_st,
                other: [cp, fm, lo_ht, sc_ht, sm_st, se_st, helmet, armor, x_buster]
            }
        }

        calculate_number(data)
    end 

    def P1_2
        data = {
            N: [3, 2],
            X: [7, 8],
            Y: [4, 1],
            XY: [6, 5],
            factor: {
              X: fm,
              Y: helmet,
              other: [aa_ht, bk_ht, cp_ht, fm_ht, lo_ht, sm_ht, sc_ht, se_ht]
            }
        }

        calculate_number(data)
    end

    def P1_3
        data = {
            N: 2,
            X: 4,
            Y: 6,
            XY: 7,
            factor: {
              X: fm_ht,
              Y: fm_st
            }
        }

        calculate_number(data)
    end

    def P1_4
        data = {
            N: 5,
            X: 3,
            Y: 2,
            XY: 6,
            factor: {
              X: se,
              Y: se_ht
            }
        }

        calculate_number(data)
    end

    def P2_1
        data = {
            N: [5, 7],
            X: [3, 2],
            Y: [1, 8],
            XY: [6, 4],
            factor: {
                X: lo,
                Y: armor,
                other: [aa, bk, cp, fm, se, aa_ht, bk_ht, aa_st, x_buster]
            }
        }

        calculate_number(data)
    end

    def P2_2
        data = {
            N: [8, 2],
            X: [4, 7],
            Y: [1, 3],
            XY: [6, 5],
            factor: {
                X: bk,
                Y: bk_ht,
                other: [aa_st, fm_st, sm_st, se_st, boots, helmet, armor, x_buster]
            }
        }

        calculate_number(data)
    end

    def P2_3
        data = {
            N: [5, 4],
            X: [8, 1],
            Y: [3, 7],
            XY: [6, 2],
            factor: {
                X: aa,
                Y: x_buster,
                other: [lo, se, cp_ht, fm_ht, se_st, helmet]
            }
        }

        calculate_number(data)
    end

    def P2_4
        data = {
            N: 2,
            X: 6,
            Y: 8,
            XY: 7,
            factor: {
                X: sm,
                Y: sc_ht
            }
        }

        calculate_number(data)
    end

    def P3_1
        data = {
            N: [1, 8],
            X: [4, 6],
            Y: [3, 7],
            XY: [2, 5],
            factor: {
                X: aa_ht,
                Y: boots,
                other: [aa, bk, bk_ht, cp_ht, fm_ht, lo_ht, sc_ht, sm_st, armor]
            }
        }

        calculate_number(data)
    end

    def P3_2
        data = {
            N: 8,
            X: 3,
            Y: 2,
            XY: 1,
            factor: {
                X: sc,
                Y: se_st
            }
        }

        calculate_number(data)
    end

    def P3_3
        data = {
            N: [2, 6],
            X: [8, 7],
            Y: [5, 3],
            XY: [4, 1],
            factor: {
                X: lo_ht,
                Y: sm_st,
                other: [aa, bk, cp, fm, lo, sm, sc, se]
            }
        }

        calculate_number(data)
    end

    def P3_4
        data = {
            N: 1,
            X: 4,
            Y: 6,
            XY: 8,
            factor: {
                X: cp,
                Y: sm_ht
            }
        }

        calculate_number(data)
    end

    def calculate_number(data)
        x_factor = data[:factor][:X]
        y_factor = data[:factor][:Y]
        value = data[find_factor(x_factor, y_factor)]

        return value if value.is_a?(Numeric)
        other_factor(value, data[:factor][:other])
    end

    # Factors:
    # N: = neither X and Y are true
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
        return value[0] if even_number_of_trues?(list)
        return value[1]
    end

    def even_number_of_trues?(list)
        list.count { |item| item }.even?
    end
end
