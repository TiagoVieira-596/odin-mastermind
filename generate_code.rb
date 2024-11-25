module Cpu
  class CpuOpponent
    @possible_colors = %w[red blue brown yellow green pink white black cyan gray orange magenta] 
    attr_reader :plays, :possible_colors

    def initialize
      @generated_code = Cpu::CpuOpponent.sample(4)
      @plays = 0
    end

    def check_code(user_code)
      user_code_correctness = { user_code[0] => 'wrong', user_code[1] => 'wrong', user_code[2] => 'wrong',
                                user_code[3] => 'wrong' }
      return 'won' if user_code == @generated_code

      user_code.each_with_index do |color, color_index|
        @generated_code.each_with_index do |entry, entry_index|
          user_code_correctness[color] = 'correct' if color == entry && color_index == entry_index
          user_code_correctness[color] = 'misplaced' if color == entry && color_index != entry_index
        end
      end
      @plays += 1
      user_code_correctness
    end
  end

  class CpuPlayer < Cpu::CpuOpponent
  end
end
