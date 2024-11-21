require_relative 'generate_code'
game_over = false
CpuOponent.generate_code
until game_over == true || CpuOponent.plays >= 12
  valid_play = false
  until valid_play != false
    valid_play = true
    print 'Take a guess: '
    user_code = gets.chomp.split
    valid_play = false if user_code.length != 4
    user_code.each do |color|
      valid_play = false unless CpuOponent.possible_colors.include?(color.downcase)
    end
  end
  current_game = CpuOponent.check_code(user_code)
  if current_game == 'won'
    game_over = true
    break
  else
    correct_guesses = current_game.values.count('correct')
    misplaced_guesses = current_game.values.count('misplaced')
    puts "You've got #{correct_guesses} correct guesses and #{misplaced_guesses} misplaced guesses"
  end
end
