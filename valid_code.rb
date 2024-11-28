require_relative 'cpu'
def get_valid_code
  valid_code = false
  until valid_code != false
    valid_code = true
    print 'Choose a code: '
    user_code = gets.chomp.split
    valid_code = false if user_code.length != 4
    user_code.each do |color|
      valid_code = false unless Cpu::CpuOpponent.possible_colors.include?(color.downcase)
    end
  end
  user_code
end
