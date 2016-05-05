module Contented
  module Helpers
    module PersonHelpers

      DIR_NAME = "_people"

      def person_in_exclude_list?(person_json)
        netid = netid_from_person_json(person_json)
        return (ENV['exclude_people'] || '').include? netid unless netid.nil?
      end

      def netid_from_person_json(person_json)
        netid_from_peoplesync_json(person_json) or netid_from_google_spreadsheet_json(person_json)
      end

      def netid_from_peoplesync_json(person_json)
        person_json["NetID"]
      end

      def netid_from_google_spreadsheet_json(person_json)
        person_json["gsx$netid"]["$t"] unless person_json["gsx$netid"].nil?
      end

      def write_person_file(person, raw_google_spreadsheet_person)
        google_spreadsheet_person = GoogleSpreadsheetPerson.new(raw_google_spreadsheet_person.to_json)
        expanded_person = ExpandedPerson.new(person, google_spreadsheet_person)

        exhibitor = ExpandedPersonExhibitor.new(expanded_person)

        Dir.mkdir(DIR_NAME) unless Dir.exist?(DIR_NAME)

        filename = "#{dir_name}/#{titlize(exhibitor.title.downcase)}.markdown"

        puts "Writing '#{exhibitor.title}' to #{filename}..."
        File.write filename, exhibitor.to_markdown
      end
    end
  end
end
