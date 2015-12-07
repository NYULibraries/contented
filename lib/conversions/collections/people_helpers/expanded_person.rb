require 'forwardable'
require_relative 'person'
require_relative 'google_spreadsheet_person'

module Conversions
  module Collections
    module PeopleHelpers
      # Combines Person class attributes with google_spreadsheet_person class attributes
      class ExpandedPerson < Person
        extend Forwardable
        def_delegators :@GoogleSpreadsheetPerson, :about, :address, :buttons, :departments, :email, :expertise, :guides, :image, :jobtitle, :keywords, :location, :netid, :phone, :space, :status, :subtitle, :title, :twitter, :publications
        def initialize(peoplesync_json, sheet_json='{}')
          super(peoplesync_json)
          @GoogleSpreadsheetPerson = GoogleSpreadsheetPerson.new(sheet_json)
        end
      end
    end
  end
end
