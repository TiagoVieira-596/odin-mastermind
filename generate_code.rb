module CpuOponent
  @@generated_code = nil
  @@plays = 0
  @@possible_colors = %w[red blue brown yellow green pink white black cyan gray orange magenta]
  def self.plays
    @@plays
  end

  def self.possible_colors
    @@possible_colors
  end

  def self.generate_code
    @@generated_code = @@possible_colors.sample(4)
  end

  def self.generated_code
    @@generated_code
  end

  def self.check_code(user_code)
    user_code_correctness = { user_code[0] => 'wrong', user_code[1] => 'wrong', user_code[2] => 'wrong', user_code[3] => 'wrong' }
    return 'won' if user_code == @@generated_code

    user_code.each_with_index do |color, color_index|
      @@generated_code.each_with_index do |entry, entry_index|
        if color == entry && color_index == entry_index
          user_code_correctness[color] = 'correct'
        end
        if color == entry && color_index != entry_index
          user_code_correctness[color] = 'misplaced'
        end
      end
    end
    @@plays += 1
    user_code_correctness
  end
end
