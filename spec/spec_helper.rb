require 'bundler'
Bundler.require
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require 'classifier_controller'