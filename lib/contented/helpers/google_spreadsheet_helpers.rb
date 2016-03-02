module Contented
  module Helpers
    module GoogleSpreadsheetHelpers
      def uri(sheet_num)
        "http://spreadsheets.google.com/feeds/list/1dulIx-iDMH4R1RwHfZs_HPGuvslQTCNcGNAkxim0v5k/#{sheet_num}/public/values?alt=json"
      end

      def google_sheet_json(sheet_num)
        JSON.parse(open(uri(sheet_num)).read)['feed']['entry']
      end

      def find_in_json(people_sheet=[], netid)
        people_sheet.find { |person_sheet| person_sheet['gsx$netid']['$t'] == netid } || {}
      end
    end
  end
end
