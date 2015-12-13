require 'open-uri'
require 'json'

module Conversions
  module Collections
    module Helpers
      # Grabs data from spreadsheet
      module GoogleSheet
        def sheet_json(sheet_num)
          JSON.parse(open(uri(sheet_num)).read)['feed']['entry'].to_json
        end

        def uri(sheet_num)
          "http://spreadsheets.google.com/feeds/list/1dulIx-iDMH4R1RwHfZs_HPGuvslQTCNcGNAkxim0v5k/#{sheet_num}/public/values?alt=json"
        end
      end
    end
  end
end
