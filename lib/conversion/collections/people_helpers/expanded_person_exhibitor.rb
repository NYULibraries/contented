require_relative 'expanded_person'
require_relative '../../helpers/markdown_presenter'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class ExpandedPersonExhibitor
        attr_accessor :expanded_person

        def initialize(expanded_person)
          @expanded_person = expanded_person
          email
        end

        def to_markdown
          MarkdownPresenter.new(expanded_person).render
        end

        private

        def email
          expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').email = expanded_person.email_address if expanded_person.email.empty?
        end
      end
    end
  end
end
