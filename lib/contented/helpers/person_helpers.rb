module Contented
  module Helpers
    module PersonHelpers
      def person_in_exclude_list?(person)
        (ENV['exclude_people'] || '').include? (person["NetID"] || '')
      end

      def person_filename(exhibitor)
        "_people/#{titlize(exhibitor.title.downcase)}.markdown"
      end

      def write_person_file(person, raw_google_spreadsheet_person)
        google_spreadsheet_person = GoogleSpreadsheetPerson.new(raw_google_spreadsheet_person.to_json)
        expanded_person = ExpandedPerson.new(person, google_spreadsheet_person)

        exhibitor = ExpandedPersonExhibitor.new(expanded_person)

        puts "Writing '#{exhibitor.title}' to #{person_filename(exhibitor)}..."
        File.write person_filename(exhibitor), exhibitor.to_markdown
      end
    end
  end
end
