module Conversion
  module Collections
    module PeopleHelpers
      module GoogleSpreadsheetHelpers
        def useful_spreadsheet_hash(spreadsheet_json_hash = {})
          spreadsheet_json_hash.keys.each do |key|
            if key.include?("gsx$")
              spreadsheet_json_hash[key[4, key.length - 1]] = spreadsheet_json_hash[key]["$t"]
            end
            spreadsheet_json_hash.delete(key)
          end
          spreadsheet_json_hash
        end
      end
    end
  end
end
