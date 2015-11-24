Dir['../../lib/conversion/helpers/*.rb'].each { |file| require file }
require File.expand_path('../../lib/conversion/collections/people_helpers/person.rb', __FILE__)
require File.expand_path('../../lib/conversion/collections/people_helpers/google_spreadsheet_person.rb', __FILE__)
require File.expand_path('../../lib/conversion/collections/people_helpers/expanded_person.rb', __FILE__)
require File.expand_path('../../lib/conversion/collections/people_helpers/person_exhibitor.rb', __FILE__)
require 'coveralls'
Coveralls.wear!

# Suppress warnings for to_not raise_error
RSpec::Expectations.configuration.warn_about_potential_false_positives = false
