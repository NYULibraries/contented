require 'contented'

namespace :contented do
  namespace :convert do

    desc 'Convert people from XML file to Markdown'
    task :people, :file do |t, args|
      file = args[:file] || '../data/staff_directory_load.xml'
      people = Contented::People.new(file)
      people.each do |p|
        person = Contented::Person.new(p)
        person.to_markdown!
      end
    end

    desc 'Convert departments from GatherContent JSON to Markdown with YAML Front Matter'
    task :departments do
      departments = Contented::Departments.new(project_id = '57459')
      departments.each do |department|
        if department.published?
          puts "Writing '#{department.title}' to #{department.filename}.markdown..."
          File.write("#{department.filename}.markdown", department.to_markdown)
        end
      end
    end

  end
end
