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
      return 'won' if player_code == secret_code

      player_code_correctness = { 'correct' => [], 'misplaced' => [] }

      # set color count
      secret_colors_count = Hash.new(0)
      secret_code.each { |color| secret_colors_count[color] += 1 }

      remaining_player_code = []
      remaining_secret_code = []

      # find correct colors
      player_code.each_with_index do |color, index|
        if color == secret_code[index]
          player_code_correctness['correct'] << color
          secret_colors_count[color] -= 1
        else
          remaining_player_code << color
          remaining_secret_code << secret_code[index]
        end
      end

      # find misplaced colors
      remaining_player_code.each do |color|
        if secret_colors_count[color].positive?
          player_code_correctness['misplaced'] << color
          secret_colors_count[color] -= 1
        end
      end
      player_code_correctness
    end
  end

  class CpuPlayer < CpuOpponent
    @@all_possible_codes = Cpu::CpuPlayer.possible_colors.repeated_permutation(4).to_a
    def initialize(secret_code)
      @plays = 0
      @generated_code = secret_code
    end

    def take_guess(previous_guess = [], correct_guesses = 0, misplaced_guesses = 0)
      return %w[red red blue blue] if previous_guess == []

      @@all_possible_codes.delete_if do |entry|
        possible_correctness = check_code(entry, previous_guess)
        if possible_correctness == 'won' ||
           (possible_correctness['correct'].length != correct_guesses ||
           possible_correctness['misplaced'].length != misplaced_guesses)
          entry
        end
      end
      @@all_possible_codes.first
    end
  end
end
