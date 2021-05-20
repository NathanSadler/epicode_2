class HangmanWord

  attr_reader :word, :guessed_letters, :wrong_guesses

  @@current_word = nil
  def initialize(word=nil)
    word_list = [:formulate, :tissue, :sentiment, :memory, :finger, :deck,
    :rise, :problem, :persist, :position]
    @word = word.downcase || word_list[rand(0..(word_list.length - 1))].to_s
    @guessed_letters = []
    @wrong_guesses = 0
  end

  # returns a version of the word where each letter has a space after it and
  # each letter that hasn't been guessed yet is replaced with two underscores
  def displayable_word
    letters = @word.split(//)
    result = ""
    letters.each do |letter|
      if @guessed_letters.include?(letter)
        result += "#{letter} "
      else
        result += "__ "
      end
    end
    return result
  end

  # Adds a letter to the list of guessed letters. Increments wrong_guesses if the
  # guessed letter isn't in the word AND that letter had not been guessed yet
  def guess_letter(letter)
    guessed_letter = letter.downcase
    if (!@guessed_letters.include?(guessed_letter) &&
      !@word.split(//).include?(guessed_letter))
      @wrong_guesses += 1
    end
    @guessed_letters.push(guessed_letter)
    @guessed_letters.uniq!
  end

end
