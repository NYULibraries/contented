require 'contented'

def uri(sheet_num)
  "http://spreadsheets.google.com/feeds/list/1dulIx-iDMH4R1RwHfZs_HPGuvslQTCNcGNAkxim0v5k/#{sheet_num}/public/values?alt=json"
end

def google_sheet_json(sheet_num)
  JSON.parse(open(uri(sheet_num)).read)['feed']['entry'].to_json
end

def find_in_json(people_sheet='[]', netid)
  JSON.parse(people_sheet).find { |person_sheet| person_sheet['gsx$netid']['$t'] == netid } || {}
end

namespace :contented do
  namespace :convert do
    desc 'Converts people into markdown'
    namespace :people do
      task :to_markdown do
        peoplesync = '[]'
        # peoplesync = JSON.parse(File.read('NYU-REP-HRI053-Libraries-Directory.json'))['Report_Entry'].to_json
        people_sheet = google_sheet_json(6)

        JSON.parse(peoplesync).each do |peoplesync_person|
          person = Contented::Conversions::Collections::People::Person.new(peoplesync_person.to_json)
          find_person = find_in_json(people_sheet, person.netid)
          people_sheet = (JSON.parse(people_sheet).delete_if { |per| per == find_person }).to_json
          google_spreadsheet_person = Contented::Conversions::Collections::People::GoogleSpreadsheetPerson.new(find_person.to_json)
          expanded_person = Contented::Conversions::Collections::People::ExpandedPerson.new(person, google_spreadsheet_person)
          exhibitor = Contented::Conversions::Collections::People::ExpandedPersonExhibitor.new(expanded_person)
          puts "#{exhibitor.title}.markdown", exhibitor.to_markdown
        end

        JSON.parse(people_sheet).each  do |person_sheet|
          google_spreadsheet_person = Contented::Conversions::Collections::People::GoogleSpreadsheetPerson.new(person_sheet.to_json)
          expanded_person = Contented::Conversions::Collections::People::ExpandedPerson.new(nil, google_spreadsheet_person)
          exhibitor = Contented::Conversions::Collections::People::ExpandedPersonExhibitor.new(expanded_person)
          puts "#{exhibitor.title}.markdown", exhibitor.to_markdown
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
