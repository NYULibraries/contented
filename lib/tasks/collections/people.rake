require_relative '../../conversions/collections/people'
require_relative '../../conversions/collections/helpers/google_sheet'
require_relative '../../conversions/collections/helpers/peoplesync'
include Conversions::Collections::People
include Conversions::Collections::Helpers::GoogleSheet
include Conversions::Collections::Helpers::Peoplesync

desc 'Convert People from PeopleSync and Spreadsheet JSON to Markdowns with YAML Front Matter'
namespace :collections do
  namespace :people do
    task :to_markdown do
      people = staff_directory(people_json, sheet_json(6))
      people.each do |person|
        puts "Writing '#{person.title}' to #{person.title}.markdown..."
        # File.write(
        puts "#{person.title}.markdown", person.to_markdown
        # )
      end
    end
  end
end