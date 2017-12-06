require 'contented'
require 'figs'

namespace :contented do
  namespace :convert do

    desc 'Convert people from XML file to Markdown'
    task :people, :file, :save_location do |t, args|
      Figs.load()
      file = args[:file] || './data/staff_directory_load.xml'
      save_location = args[:save_location] || './_people'
      people = Contented::SourceReaders::PeopleXML.new(file)
      exclude_people = Figs.env.exclude_people || []
      FileUtils.mkdir_p(save_location)
      # Expect people to be a hash
      people.each do |p|
        # Expect p to be a hash
        person = Contented::Person.new(p, save_location)
        unless exclude_people.include?(person.net_id)
          # Save the file as markdown
          person.save_as_markdown!
        end
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
