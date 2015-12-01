require_relative 'expanded_person'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class PersonExhibitor
        attr_accessor :expanded_person

        def initialize(expanded_person)
          @expanded_person = expanded_person
        end
      end
    end
  end
end
