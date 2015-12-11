require 'forwardable'
require_relative 'person'
require_relative 'google_spreadsheet_person'

module Conversions
  module Collections
    module People
      # Combines Person class attributes with google_spreadsheet_person class attributes
      class ExpandedPerson
        extend Forwardable
        def_delegators :@Person, :work_phone, :email_address, :all_positions_jobs, :backup_title
        def_delegators :@GoogleSpreadsheetPerson, :address, :buttons, :departments, :email, :expertise, :guides, :image, :jobtitle, :keywords, :location, :phone, :space, :status, :subtitle, :title, :twitter, :publications

        def initialize(person, google_person)
          @Person = person
          @GoogleSpreadsheetPerson = google_person
        end
      end
    end
  end
end
