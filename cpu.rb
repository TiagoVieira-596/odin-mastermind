module Cpu
  class CpuOpponent
    @@possible_colors = %w[red blue yellow green cyan magenta]
    @@repeated_colors = %w[red blue yellow green cyan magenta].map do |color|
      Array.new(4, color)
    end

    attr_reader :plays, :generated_code

    def self.possible_colors
      @@possible_colors
    end

    def self.repeated_colors
      @@repeated_colors
    end

    def initialize
      @generated_code = CpuOpponent.repeated_colors.flatten.sample(4)
      @plays = 0
    end

    def play
      @plays += 1
    end

    def check_code(player_code, secret_code = @generated_code)
      player_code_correctness = {}.compare_by_identity
      return 'won' if player_code == secret_code

      until player_code_correctness.keys.length == 4
        player_code.each_with_index do |color, color_index|
          secret_code.each_with_index do |entry, entry_index|
            unless secret_code.include?(color)
              player_code_correctness[color] = 'wrong'
              break
            end
            if color == entry && color_index == entry_index

              player_code_correctness[color] = 'correct'
              break
            end

            player_code_correctness.each_pair do |key, value|
              next unless key == color && value == 'misplaced' &&
                          secret_code.count(color) < player_code_correctness.keys.count(color) &&
                          secret_code.count(color) != (player_code.count(color))

              player_code_correctness[key] = 'wrong'
            end
            player_code_correctness[color] = 'misplaced'
            next unless secret_code.count(color) <
                        player_code_correctness.to_a.count([color, 'misplaced']) +
                        player_code_correctness.to_a.count([color, 'correct'])

            player_code_correctness[color] = 'wrong'
          end
        end
      end
      p player_code
      p player_code_correctness
    end
  end

  class CpuPlayer < CpuOpponent
    def initialize(secret_code)
      @plays = 0
      @generated_code = secret_code
      @all_possible_codes = Cpu::CpuPlayer.possible_colors.repeated_permutation(4).to_a
    end

    def take_guess(correct_guesses = 0, misplaced_guesses = 0, previous_guess = [])
      return %w[red red blue blue] if previous_guess == []

      @all_possible_codes.delete_if do |entry|
        possible_code_correctness = check_code(entry, previous_guess)
        if possible_code_correctness == 'won' ||
           (possible_code_correctness.values.count('correct') == correct_guesses &&
           possible_code_correctness.values.count('misplaced') == misplaced_guesses)
          entry
        end
      end
      @all_possible_codes.first
    end
  end
end
