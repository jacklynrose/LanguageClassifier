require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require 'language_classifier'
require 'madeleine_commands'