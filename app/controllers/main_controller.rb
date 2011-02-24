class MainController < ApplicationController
  def index
  end

  def check_spelling
    result = @@spell_checker.check(params[:word])
  end

  def test_misspelled_words
    @words = []
    5.times do
      word_set = @@misspelled_word_generator.random_word
      word_set[:corrected] = @@spell_checker.check(word_set[:misspelled])
      @words << word_set
    end
  end
end
