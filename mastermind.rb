require_relative 'generate_code'
require 'colorize'
game_won = false
CpuOponent.generate_code
until game_won == true || CpuOponent.plays >= 12
  valid_play = false
  until valid_play != false
    valid_play = true
    print 'Take a guess: '
    user_code = gets.chomp.split
    valid_play = false if user_code.uniq.length != 4
    user_code.each do |color|
      valid_play = false unless CpuOponent.possible_colors.include?(color.downcase)
    end
  end
  current_game = CpuOponent.check_code(user_code)
  if current_game == 'won'
    game_won = true
    break
  else
    correct_guesses = current_game.values.count('correct')
    misplaced_guesses = current_game.values.count('misplaced')
    user_code.each do |color|
      print color.colorize(color.to_sym) << ' '
    end
    puts ''
    puts "You've got #{correct_guesses} correct guesses and #{misplaced_guesses} misplaced guesses"
  end
end
puts "You've cracked the code!!!" if game_won
puts 'You have no more guesses, game lost.' unless game_won
