module Contented
  module Helpers
    module GoogleSpreadsheetHelpers

      def google_sheet_error(environment_var_name)
        raise Exception.new("Please ensure all Google Spreadsheet environment variables are set
        (#{environment_var_name}).")
      end

      def sheet_uri(environment_var_name)
        ENV[environment_var_name] or google_sheet_error
      end

      def google_sheet_json(environment_var_name = 'google_sheet_uri')
        JSON.parse(open(sheet_uri(environment_var_name)).read)['feed']['entry']
      end

      def find_in_json(people_sheet=[], netid)
        people_sheet.find { |person_sheet| person_sheet['gsx$netid']['$t'] == netid } || {}
      end
    end
  end
end
