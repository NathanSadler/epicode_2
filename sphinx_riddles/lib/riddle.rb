class Riddle

  attr_reader :riddle, :answer
  @@all_riddles = []

  def initialize(riddle, answer)
    @riddle = riddle
    @answer = answer
    @@all_riddles.push(self)
  end

  def right_answer?(given_answer)
    return @answer.upcase == given_answer.upcase
  end
end
