module Contented
  module Conversions
    module Collections
      module Helpers
        # Removes the counter-productive 'gsx$' and '$t' from the google sheet data
        module GoogleSpreadsheetHelpers
          def useful_spreadsheet_hash(spreadsheet_json_hash = {})
            spreadsheet_json_hash.keys.each do |key|
              if key.include?('gsx$')
                spreadsheet_json_hash[key[4, key.length - 1]] = spreadsheet_json_hash[key]['$t']
              end
              spreadsheet_json_hash.delete(key)
            end
            spreadsheet_json_hash
          end
        end
      end
    end
  end
end
