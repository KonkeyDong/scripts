require 'minitest/autorun'

require_relative 'MMX_password_crack'

describe MMXPasswordCrack do
    before(:each) do
        @password = MMXPasswordCrack.new
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
            assert_equal @password.P1_1, 4
            @password.stub :even_number_of_trues?, false do
                assert_equal @password.P1_1, 1
            end
        end

        it 'should return 2 or 7 if Chill Penguin heart tank is set' do
            @password.cp_ht = true
            assert_equal @password.P1_1, 2
            @password.stub :even_number_of_trues?, false do
                assert_equal @password.P1_1, 7
            end
        end

        it 'should return 6 or 5 if Armored Armadillo sub tank is set' do
            @password.aa_st = true
            assert_equal @password.P1_1, 6
            @password.stub :even_number_of_trues?, false do
                assert_equal @password.P1_1, 5
            end
        end

        it 'should return 8 or 3 if Chill Penguin heart tank and Armored Armadillo sub tank is set' do
            @password.cp_ht = true
            @password.aa_st = true
            assert_equal @password.P1_1, 8
            @password.stub :even_number_of_trues?, false do
                assert_equal @password.P1_1, 3
            end
        end
    end
end
