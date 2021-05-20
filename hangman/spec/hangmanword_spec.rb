require('rspec')
require('hangmanword')

describe '#HangmanWord' do
  before(:all) do
    @game = HangmanWord.new("foobar")
  end

  describe('#guess_letter') do
    it('adds a letter to its list of guessed letters') do
      @game.guess_letter('f')
      expect(@game.guessed_letters.include?('f')).to(eq(true))
    end
    it("doesn't increment guess_letter when a correct guess is made") do
      expect(@game.wrong_guesses).to(eq(0))
    end
    it('increments wrong_guesses when an incorrect guess is made') do
      @game.guess_letter('z')
      expect(@game.wrong_guesses).to(eq(1))
    end
    it("doesn't increment wrong_guesses for a guess that was already made") do
      @game.guess_letter('z')
      expect(@game.wrong_guesses).to(eq(1))
    end
  end

  describe('#displayable_word') do
    it('returns a version of the letter with unguessed letters replaced with '+
    'two underscores and a space after every letter') do
      expect(@game.guess_letter('b'))
      expect(@game.guess_letter('a'))
      expect(@game.displayable_word).to(eq("f __ __ b a __ "))
    end
  end
end
