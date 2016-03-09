require 'contented'
include Contented::Conversions::Collections::People
include Contented::Helpers::TitleHelpers
include Contented::Helpers::PeopleSyncHelpers
include Contented::Helpers::PersonHelpers
include Contented::Helpers::GoogleSpreadsheetHelpers

namespace :contented do
  namespace :convert do
    desc 'Converts people into markdown'
    namespace :people do
      namespace :people_sync do
        task :to_markdown do
          people_sync_people = people_sync_json || []
          google_spreadsheet_people = google_sheet_json(6)

          people_sync_people.each do |people_sync_person|
            # skip if the person is in excluded list
            next if person_in_exclude_list? people_sync_person
            # create a person object
            person = Person.new(people_sync_person.to_json)
            # Find person from google sheet and pop it off
            google_spreadsheet_person = find_in_json(google_spreadsheet_people, person.netid)
            google_spreadsheet_people.delete(google_spreadsheet_person)
            # Expand the person
            write_person_file(person, google_spreadsheet_person)
          end
        end
      end

      namespace :google_spreadsheet do
        task :to_markdown do
          google_spreadsheet_people = google_sheet_json_nyu_ad_sh(2)

          google_spreadsheet_people.each  do |google_spreadsheet_person|
            next if person_in_exclude_list? google_spreadsheet_person
            write_person_file(nil, google_spreadsheet_person)
          end
        end
      end
    end

    desc 'Convert departments from GatherContent JSON to Markdowns with YAML Front Matter'
    task :departments do
      departments = Contented::GatherContent::Departments.new(project_id = '57459')
      departments.each do |department|
        if department.published?
          puts "Writing '#{department.title}' to #{department.filename}.markdown..."
          File.write("#{department.filename}.markdown", department.to_markdown)
        end
      end
    end
  end
end
