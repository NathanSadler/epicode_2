class Riddle

  attr_reader :riddle, :answer
  @@all_riddles = {}
  @@riddle_count = 0

  def initialize(riddle, answer)
    @riddle = riddle
    @answer = answer
    @@all_riddles[@@riddle_count] = self
    @@riddle_count += 1
  end

  def right_answer?(given_answer)
    return @answer.upcase == given_answer.upcase
  end
end
