require File.expand_path('../../lib/conversion/convert.rb', __FILE__)
Dir['../../lib/conversion/helpers/*.rb'].each { |file| require file }
Dir['../../lib/conversion/collections/*.rb'].each { |file| require file }
require 'coveralls'
Coveralls.wear!

# Suppress warnings for to_not raise_error
RSpec::Expectations.configuration.warn_about_potential_false_positives = false
