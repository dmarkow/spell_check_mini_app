class ApplicationController < ActionController::Base
  protect_from_forgery
  # Load these as class variables rather than instance variables; we don't want
  # to have to read in the 250,000-word list every single time we run a spell
  # check.
  @@spell_checker = SpellChecker.new
  @@misspelled_word_generator = MisspelledWordGenerator.new
end
