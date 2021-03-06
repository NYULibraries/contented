require 'contented'

unless ENV["DISABLE_FIGS"]
  begin; require 'figs'; Figs.load; rescue LoadError; end
end

namespace :contented do
  namespace :collections do
    desc 'Convert people from XML file to Markdown'
    task :people, :file, :save_location do |t, args|
      file = args[:file] || './data/staff_directory_load.xml'
      save_location = args[:save_location] || './_people'
      people = Contented::SourceReaders::PeopleXML.new(file)
      exclude_people = Figs.env.exclude_people || []
      manage_people_manually = Figs.env.manage_people_manually || []
      FileUtils.mkdir_p(save_location)
      # Delete users not excluded for managing manually
      Dir["#{save_location}/*.markdown"].each do |f|
        filename = f.split('/').last.split('.').first
        FileUtils.rm(f) unless manage_people_manually.include?(filename)
      end
      # Expect people to be a hash
      people.each do |p|
        # Expect p to be a hash
        person = Contented::Collections::Person.new(p)
        unless exclude_people.include?(person.net_id)
          # Save the file as markdown
          person.save_as_markdown! save_location: save_location
        end
      end
    end

    task :classrooms, [:save_location] do |t, args|
      save_location = args[:save_location] || './_classrooms'

      FileUtils.mkdir_p(save_location)
      FileUtils.rm_rf(Dir.glob("#{save_location}/*"))

      options = {
        host: ENV["SCHEDUALL_HOST"],
        username: ENV["SCHEDUALL_USERNAME"],
        password: ENV["SCHEDUALL_PASSWORD"],
      }

      scheduall = Contented::SourceReaders::Scheduall.new(options)
      scheduall.fetch_rooms
      scheduall.save_rooms!(save_location)
      scheduall.close

      scheduall.each do |r|
        room = Contented::Collections::CampusMediaRoom.new(r)
        room.save_as_markdown! save_location: save_location
      end
    end
  end
end
