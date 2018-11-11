require 'minitest/autorun'

require_relative 'MMX_password_crack'

describe MMXPasswordCrack do
    before(:each) do
        @password = MMXPasswordCrack.new
        @password.bosses
        @password.heart_tanks
        @password.sub_tanks
        @password.suit_parts
    end

    describe '#number?, #even_number_of_trues?, #other_factor, #find_factor' do
        it 'should return true if a number' do
            assert_equal @password.number?(1), true
            assert_equal @password.number?(Array.new), false
        end

        it 'should return true if an array of boolean has an even number' do
            assert_equal @password.even_number_of_trues?([false, false]), true
            assert_equal @password.even_number_of_trues?([false, true]), false
            assert_equal @password.even_number_of_trues?([true, true]), true
        end

        it 'should return the first value if an even number of booleans in an array' do
            assert_equal @password.other_factor(%w(first second), [false]), 'first'
            assert_equal @password.other_factor(%w(first second), [true]), 'second'
            assert_equal @password.other_factor(%w(first second), [true, true]), 'first'
        end

        it 'should return the correct symbol' do
            assert_equal @password.find_factor(false, false), :N
            assert_equal @password.find_factor(true, false), :X
            assert_equal @password.find_factor(false, true), :Y
            assert_equal @password.find_factor(true, true), :XY
        end
    end

    describe '#P1_1' do
        it 'should return 4 or 1 if nothing is set' do
            assert_number(:P1_1, [], 4, 1)
        end

        it 'should return 2 or 7 if Chill Penguin heart tank is set' do
            assert_number(:P1_1, %i(cp_ht), 2, 7)
        end

        it 'should return 6 or 5 if Armored Armadillo sub tank is set' do
            assert_number(:P1_1, %i(aa_st), 6, 5)
        end

        it 'should return 8 or 3 if Chill Penguin heart tank and Armored Armadillo sub tank are set' do
            assert_number(:P1_1, %i(cp_ht aa_st), 8, 3)
        end
    end

    describe '#P1_2' do
        it 'should return 3 or 1 if nothing is set' do
            assert_number(:P1_2, [], 3, 2)
        end

        it 'should return 7 or 8 if Flame Mammoth is set' do
            assert_number(:P1_2, %i(fm), 7, 8)
        end

        it 'should return 4 or 1 if the Helmet is set' do
            assert_number(:P1_2, %i(helmet), 4, 1)
        end

        it 'should return 6 or 5 if Flame Mammoth and Helmet are set' do
            assert_number(:P1_2, %i(fm helmet), 6, 5)
        end
    end

    describe '#P1_3' do
        it 'should return 2 if nothing is set' do
            assert_number(:P1_3, [], 2)
        end

        it 'should return a 4 if Flame Mammoth heart tank is set' do
            assert_number(:P1_3, %i(fm_ht), 4)
        end

        it 'should return a 6 if Flame Mammoth sub tank is set' do
            assert_number(:P1_3, %i(fm_st), 6)
        end

        it 'should return a 7 if Flame Mammoth heart tank and sub tank are set' do
            assert_number(:P1_3, %i(fm_ht fm_st), 7)
        end
    end

    describe '#P1_4' do
        it 'should return 5 if nothing is set' do
            assert_number(:P1_4, %i(), 5)
        end

        it 'should return 3 if Storm Eagle is set' do
            assert_number(:P1_4, %i(se), 3)
        end

        it 'should return 2 if Storm Eagle heart tank is set' do
            assert_number(:P1_4, %i(se_ht), 2)
        end

        it 'should return 6 if Storm Eagle and heart tank are set' do
            assert_number(:P1_4, %i(se se_ht), 6)
        end
    end

    def assert_number(method, fields, expected_value, other_value = nil)
        turn_on_fields(fields)
        assert_equal @password.send(method), expected_value
        calculate_alternative_number(method, other_value)
    end

    def calculate_alternative_number(method, expected_value)
        return unless expected_value

        @password.stub :even_number_of_trues?, false do
            assert_equal @password.send(method), expected_value
        end
    end

    def turn_on_fields(fields)
        fields.each { |field| @password.send("#{field}=", true) }
    end
end
