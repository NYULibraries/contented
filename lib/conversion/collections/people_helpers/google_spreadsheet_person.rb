require 'json'
require_relative 'google_spreadsheet_helpers'

module Conversion
  module Collections
    module PeopleHelpers
      # Edits the Google Sheet People workbook for markdown conversion
      class GoogleSpreadsheetPerson
        include GoogleSpreadsheetHelpers
        attr_accessor :about, :address, :buttons, :departments, :email, :expertise, :guides, :image, :jobtitle, :keywords, :location, :netid, :phone, :space, :status, :subtitle, :title, :twitter

        def initialize(json_data)
          JSON.parse(json_data).each_pair do |var, val|
            useful_key_value = useful_spreadsheet_hash({var => val })
            send("#{useful_key_value.keys[0]}=", useful_key_value.values[0]) if useful_key_value.keys[0] && respond_to?(useful_key_value.keys[0])
          end
        end

        def to_markdown
        end
      end
    end
  end
end
