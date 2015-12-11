require_relative '../../conversions/collections/people'
include Conversions::Collections::People

desc 'Convert People from PeopleSync and Spreadsheet JSON to Markdowns with YAML Front Matter'
namespace :collections do
  namespace :people do
    task :to_markdown do
      people = staff_directory()
      people.each do |person|
        puts "Writing '#{person.title}' to #{person.title}.markdown..."
        File.write("#{person.title}.markdown", person.to_markdown)
      end
    end
  end
end