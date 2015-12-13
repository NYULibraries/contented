require_relative '../conversions/collections/services'
require_relative '../conversions/collections/helpers/google_sheet'
include Conversions::Collections::Services
include Conversions::Collections::Helpers::GoogleSheet

namespace :contented do
  namespace :convert do
    desc 'Converts people into markdown'
    task :people do |task|
      #
    end
  end
  namespace :services do
    desc 'Converts people into markdown'
    task :to_markdown do
      services = services(sheet_json(8))
      services.each do |service|
        puts "Writing '#{service.title}' to #{service.title}.markdown..."
        puts "#{service.title}.markdown", service.to_markdown
      end
    end
  end
end
