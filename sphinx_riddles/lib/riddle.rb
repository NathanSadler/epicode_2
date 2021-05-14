class Riddle

  attr_reader :riddle, :answer, :id
  @@all_riddles = {}
  @@riddle_count = 0

  def initialize(riddle, answer)
    @riddle = riddle
    @answer = answer
    @id = @@riddle_count
    @@all_riddles[@@riddle_count] = self
    @@riddle_count += 1
  end

  def right_answer?(given_answer)
    return @answer.upcase == given_answer.upcase
  end

  def self.all_riddles
    @@all_riddles.values
  end

  def self.clear
    @@all_riddles = {}
    @@riddle_count = 0
  end
end
