require File.expand_path('../../lib/conversion/convert.rb', __FILE__)
Dir['../../lib/conversion/helpers/*.rb'].each { |file| require file }
Dir['../../lib/conversion/parse_people/*.rb'].each { |file| require file }
require 'coveralls'
Coveralls.wear!
