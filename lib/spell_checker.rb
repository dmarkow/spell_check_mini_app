# My awesome spell checker. It checks spelling. And is awesome.
#
class SpellChecker

  # Sets up a new SpellChecker instance using the specified word list. The
  # default is /usr/share/dict/words, which is used on Mac OS X machines.
  #
  # The word list is assigned to one large string instead of putting each word
  # into an array. Regular expression searches against a string are MUCH faster
  # than iterating through each record using something like Array#detect
  #
  def initialize(word_list_path=Rails.root.join("lib","words").to_s)
    @word_list = File.read(word_list_path)# .split("\n")
  end

  # Check the word in the following order:
  # 1. Exact match. We want to check the exact input at least once, in case the
  #    user typed in something like "Job" (which is different from "job" as far
  #    as my words file is concerned.)
  # 2. Lowercase match
  # 3. Case-insensitive match (mainly to handle proper words like "Canada")
  # 4. Incorrect vowel match
  # 5. Extra letter match
  #
  def check(word)
    word = word.dup # Otherwise, downcase! will alter the calling code's variable
    exact_match(word) || exact_match(word.downcase!) || case_insensitive_match(word) || alternate_vowel_match(word) || extra_letter_match(word)
  end

  private

  # Search for a perfect match
  #
  def exact_match(word)
    @word_list[/^#{word}$/]
  end

  # Same as #exact_match, but case-insensitive
  #
  def case_insensitive_match(word)
    @word_list[/^#{word}$/i]
  end

  # Replace existing vowels with regexp matchers for any vowels, and then rerun the
  # case-insensitive search.
  #
  def alternate_vowel_match(word)
    vowel_regexp_word = word.gsub(/[aeiou]/, "[aeiou]")
    case_insensitive_match(vowel_regexp_word)
  end

  # Check to see if there are duplicate letters. If so, remove one and then
  # recursively run back through SpellChecker#check. The recursion will execute
  # once for each set of duplicate letters if finds, but will return the first
  # match it find.
  #
  # Example steps:
  # shabbyy -> shabyy -> shaby -> NO SUGGESTION (try next pair of letters) ->
  # shabbyy -> shabby -> MATCH!
  #
  def extra_letter_match(word)
    result = "NO SUGGESTION"

    word.scan(/(\w)\1/) do
      # We want to leave the original word intact
      shortened_word = word.dup

      shortened_word.slice!(Regexp.last_match.offset(0).first)
      break if (result = check(shortened_word)) != "NO SUGGESTION"
    end

    result
  end


end
