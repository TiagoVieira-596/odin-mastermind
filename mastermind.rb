require_relative 'generate_code'
valid_play = false
until valid_play != false
  valid_play = true
  print 'Take a guess: '
  user_code = gets.chomp.split
  valid_play = false if user_code.length != 4
  user_code.each do |color|
    valid_play = false unless CpuOponent.possible_colors.include?(color.lowercase)
  end
end
