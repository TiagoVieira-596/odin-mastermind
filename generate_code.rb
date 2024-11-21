module CpuOponent
  @@generated_code = nil
  @@possible_colors = %w[red blue brown yellow green pink purple white black]
  def self.generate_code
    @@generated_code = @@possible_colors.sample(4)
  end

  def self.check_code(user_code)
    user_code_correctness = { user_code[0] => nil, user_code[1] => nil, user_code[2] => nil, user_code[3] => nil }
    return "You've cracked the code!!!" if user_code == @@generated_code

    user_code.each do |color|
      @@generated_code.each do |entry|
        if color == entry && user_code.index(color) == @@generate_code.index(entry)
          user_code_correctness[color] = 'correct'
        end
        if color == entry && user_code.index(color) != @@generated_code.index(entry)
          user_code_correctness[color] = 'misplaced'
        else
          user_code_correctness[color] = 'wrong'
        end
      end
    end
    user_code_correctness
  end
end
