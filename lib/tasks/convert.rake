require 'contented'
include Contented::Conversions::Collections::People
include Contented::Helpers::TitleHelpers
include Contented::Helpers::PeopleSyncHelpers

def uri(sheet_num)
  "http://spreadsheets.google.com/feeds/list/1dulIx-iDMH4R1RwHfZs_HPGuvslQTCNcGNAkxim0v5k/#{sheet_num}/public/values?alt=json"
end

def google_sheet_json(sheet_num)
  JSON.parse(open(uri(sheet_num)).read)['feed']['entry']
end

def find_in_json(people_sheet=[], netid)
  people_sheet.find { |person_sheet| person_sheet['gsx$netid']['$t'] == netid } || {}
end

def person_in_exclude_list?(person)
  (ENV['exclude_people'] || '').include? person["NetID"]
end

def person_filename(exhibitor)
  "_people/#{titlize(exhibitor.title.downcase)}.markdown"
end

def write_file(person, spreadsheet)
  google_spreadsheet_person = GoogleSpreadsheetPerson.new(spreadsheet.to_json)
  expanded_person = ExpandedPerson.new(person, google_spreadsheet_person)

  exhibitor = ExpandedPersonExhibitor.new(expanded_person)

  puts "Writing '#{exhibitor.title}' to #{person_filename(exhibitor)}..."
  File.write person_filename(exhibitor), exhibitor.to_markdown
end

namespace :contented do
  namespace :convert do
    desc 'Converts people into markdown'
    namespace :people_sync do
      namespace :people do
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
            write_file(person, google_spreadsheet_person)
          end
        end
      end
    end

    namespace :google_spreadsheet do
      namespace :people do
        task :to_markdown do
          google_spreadsheet_people = google_sheet_json(6)

          google_spreadsheet_people.each  do |google_spreadsheet_person|
            next if person_in_exclude_list? google_spreadsheet_person
            write_file(nil, GoogleSpreadsheetPerson.new(google_spreadsheet_person.to_json))
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
