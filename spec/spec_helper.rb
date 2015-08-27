require File.expand_path('../../lib/convert/convert.rb', __FILE__)
Dir['../../lib/convert/helpers/*.rb'].each { |file| require file }
require 'webmock/rspec'
require 'simplecov'
SimpleCov.start
