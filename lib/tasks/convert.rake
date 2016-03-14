require 'contented'
include Contented::Conversions::Collections::People
include Contented::Helpers::TitleHelpers
include Contented::Helpers::PeopleSyncHelpers
include Contented::Helpers::PersonHelpers
include Contented::Helpers::GoogleSpreadsheetHelpers

namespace :contented do
  namespace :convert do
    namespace :people do
      desc 'Converts people from PeopleSync into markdown after enriching with data from a Google Spreadsheet'
      namespace :people_sync do
        task :to_markdown do
          people_sync_people = people_sync_json || []
          google_spreadsheet_people = google_sheet_json

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

      desc 'Converts people from a Google Spreadsheet into markdown'
      namespace :google_spreadsheet do
        task :to_markdown, [:environment_var_name] do |task_name, args|
          if args[:environment_var_name].nil?
            google_spreadsheet_people = google_sheet_json
          else
            google_spreadsheet_people = google_sheet_json(args[:environment_var_name])
          end

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
