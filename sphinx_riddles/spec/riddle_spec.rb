require 'rspec'
require 'riddle'

describe '#Riddle' do
  before(:each) do
    @riddle = Riddle.new("What can you put in a bucket to make it lighter?", "A hole")
  end

  describe ('#right_answer?') do
    it('Returns true if the given answer is correct') do
      expect(@riddle.right_answer?('a hole')).to(eq(true))
    end
    it('Returns false if the given answer is incorrect') do
      expect(@riddle.right_answer?('a feather')).to(eq(false))
    end
  end
end
