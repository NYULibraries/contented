require 'forwardable'
require_relative 'person'
require_relative 'google_spreadsheet_person'

module Conversion
  module Collections
    module PeopleHelpers
      # Combines Person class attributes with google_spreadsheet_person class attributes
      class ExpandedPerson < Person
        extend Forwardable
        def_delegators :@GoogleSpreadsheetPerson, :about, :address, :buttons, :departments, :email, :expertise, :guides, :image, :jobtitle, :keywords, :location, :netid, :phone, :space, :status, :subtitle, :title, :twitter, :publications
        def initialize(json_data, json_data_expand='{}')
          super(json_data)
          @GoogleSpreadsheetPerson = GoogleSpreadsheetPerson.new(json_data_expand)
        end
      end
    end
  end
end
