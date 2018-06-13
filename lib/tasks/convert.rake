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
        person = Contented::Collections::Person.new(p, save_location)
        unless exclude_people.include?(person.net_id)
          # Save the file as markdown
          person.save_as_markdown!
        end
      end
    end

    namespace :campusmedia do
      desc 'Convert rooms from Scheduall SQL data to Markdown'
      task :rooms, [:save_location] do |t, args|
        Figs.load

        save_location = args[:save_location] || './_campusmedia'

        options = {
          host: Figs.env["SCHEDUALL_HOST"],
          username: Figs.env["SCHEDUALL_USERNAME"],
          password: Figs.env["SCHEDUALL_PASSWORD"],
        }

        scheduall = Contented::SourceReaders::Scheduall.new(options)
        scheduall.fetch_rooms
        scheduall.close

        rooms = scheduall.rooms
        rooms.each do |r|
          room = Contented::Collections::CampusMedia::Room.new(r, save_location)
          room.save_as_markdown!
        end
      end
    end
  end
end
