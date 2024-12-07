require_relative 'cpu'
require_relative 'valid_code'
require 'colorize'
game_won = false
cpu_player = nil
while cpu_player.nil?
  print 'Play against the cpu? '
  game_mode = gets.chomp.downcase
  cpu_player = if %w[no n].include?(game_mode)
                 false
               elsif %w[yes y].include?(game_mode)
                 true
               end
end
if cpu_player == false
  cpu = Cpu::CpuOpponent.new
  until game_won == true || cpu.plays >= 12
    user_code = get_valid_code.map(&:downcase)
    current_guess_correctness = cpu.check_code(user_code)
    cpu.play
    if current_guess_correctness == 'won'
      game_won = true
      break
    else
      correct_guesses = current_guess_correctness['correct'].length
      misplaced_guesses = current_guess_correctness['misplaced'].length
      user_code.each do |color|
        print color.colorize(color.to_sym) << ' '
      end
      puts "\n"
      puts "You've got #{correct_guesses} correct guesses and #{misplaced_guesses} misplaced guesses"
    end
  end
  puts "You've cracked the code!!!" if game_won
  puts 'You have no more guesses, game lost.' unless game_won
else
  secret_code = get_valid_code.map(&:downcase)
  cpu = Cpu::CpuPlayer.new(secret_code)
  game_won = false
  new_cpu_guess = cpu.take_guess
  until game_won == true || cpu.plays >= 12
    current_cpu_guess = new_cpu_guess
    if current_cpu_guess.nil?
      puts "You've tricked me!!! >:("
      return
    end
    print 'Cpu guessed: '
    current_cpu_guess.each do |color|
      print color.colorize(color.to_sym) << ' '
    end
    puts "\n"
    misplaced_guesses = nil
    correct_guesses = nil
    until ((misplaced_guesses.is_a? Numeric) && misplaced_guesses >= 0 && misplaced_guesses <= 4) &&
          ((correct_guesses.is_a? Numeric) && correct_guesses >= 0 && correct_guesses <= 4) &&
          misplaced_guesses + correct_guesses <= 4
      print 'How many misplaced guesses: '
      misplaced_guesses = gets.chomp.to_i
      print 'How many correct guesses: '
      correct_guesses = gets.chomp.to_i
    end
    if correct_guesses == 4
      game_won = true
      break
    end
    new_cpu_guess = cpu.take_guess(current_cpu_guess, correct_guesses, misplaced_guesses)
    cpu.play
  end
  puts 'The computer won the game!!!' if game_won == true
  puts 'The computer ran out of guesses.' if game_won == false
end
