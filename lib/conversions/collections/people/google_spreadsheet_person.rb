require 'json'
require_relative '../helpers/google_spreadsheet_helpers'
require_relative 'person'

module Conversions
  module Collections
    module People
      # Edits the Google Sheet People workbook for markdown conversion
      class GoogleSpreadsheetPerson < Person
        include Conversions::Collections::Helpers::GoogleSpreadsheetHelpers
        attr_accessor :about, :address, :buttons, :departments, :email, :expertise, :guides, :image, :jobtitle, :keywords, :location, :netid, :phone, :space, :status, :subtitle, :title, :twitter, :publications

        def initialize(json_data)
          useful_spreadsheet_hash(JSON.parse(json_data)).each_pair { |var, val| send("#{var}=", val) if respond_to?(var) && !val.empty? }
        end
      end
    end
  end
end