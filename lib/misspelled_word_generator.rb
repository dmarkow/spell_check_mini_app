#!/usr/bin/env ruby

# My awesome misspelled word generator. It sucks at spelling, which is kind of the point.
#
class MisspelledWordGenerator

  # Sets up a new MisspelledWordGenerator instance using the specified word list. The
  # default is /usr/share/dict/words, which is used on Mac OS X machines.
  #
  def initialize(word_list_path=Rails.root.join("lib","words").to_s)
    @words = File.read(word_list_path).split("\n")
  end

  # Take a random entry from the word list and make it misspelled using random
  # techniques. In the rare instance that the "misspelled" word is a valid
  # dictionary word, pick a new one.
  def random_word
    original_word   = @words.shuffle.first.dup
    misspelled_word = original_word.dup
    misspelled_word = change_vowels(misspelled_word)
    misspelled_word = add_letters(misspelled_word)
    misspelled_word = change_case(misspelled_word)
    @words.include?(misspelled_word) ? random_word : {:original => original_word, :misspelled => misspelled_word}
  end

  private

  # Replace all vowels with a random vowel
  def change_vowels(word)
    word.scan(/[aeiou]/) do
      word[Regexp.last_match.offset(0).first] = %w(a e i o u)[rand(5)]
    end
    word
  end

  # Add up to three duplicate letters
  def add_letters(word)
    rand(3).times do
      position_to_duplicate = rand(word.length)
      word.insert(position_to_duplicate, word[position_to_duplicate])
    end
    word
  end

  # Convert up to three letters to uppercase
  def change_case(word)
    rand(3).times do
      position_to_uppercase = rand(word.length)
      word[position_to_uppercase] = word[position_to_uppercase].upcase
    end
    word
  end
end
