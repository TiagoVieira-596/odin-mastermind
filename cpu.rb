module Cpu
  class CpuOpponent
    @@possible_colors = %w[red blue yellow green cyan magenta].map do |color|
      Array.new(4, color)
    end
    attr_reader :plays

    def self.possible_colors
      @@possible_colors.flatten.uniq
    end

    def initialize
      @generated_code = CpuOpponent.possible_colors.flatten.sample(4)
      @plays = 0
    end

    def check_code(player_code)
      player_code_correctness = { player_code[0] => 'wrong', player_code[1] => 'wrong', player_code[2] => 'wrong',
                                  player_code[3] => 'wrong' }
      return 'won' if player_code == @generated_code

      player_code.each_with_index do |color, color_index|
        @generated_code.each_with_index do |entry, entry_index|
          player_code_correctness[color] = 'correct' if color == entry && color_index == entry_index
          player_code_correctness[color] = 'misplaced' if color == entry && color_index != entry_index
        end
      end
      @plays += 1
      player_code_correctness
    end
  end

  class CpuPlayer < CpuOpponent
    def initialize(secret_code)
      @plays = 0
      @generated_code = secret_code
    end

    def take_guess(correct_guesses = 0, misplaced_guesses = 0, previous_guess = [])
      possible_correct = previous_guess.slice([0, 1, 2].sample, correct_guesses)
      possible_misplaced = previous_guess.sample(misplaced_guesses)
      random_missing_colors = CpuPlayer.possible_colors.flatten.sample(4 - misplaced_guesses - correct_guesses)
      random_missing_colors.push(possible_correct, possible_misplaced).flatten.filter { |entry| !entry.nil? }
    end
  end
end
