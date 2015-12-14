require_relative '../conversions/collections/departments'
require_relative '../conversions/collections/helpers/google_sheet'
include Conversions::Collections::Departments
include Conversions::Collections::Helpers::GoogleSheet

namespace :contented do
  namespace :convert do
    desc 'Converts people into markdown'
    task :people do |task|
      #
    end
  end
  namespace :departments do
    desc 'Converts Departments into markdown'
    task :to_markdown do
      departments = departments(sheet_json(2))
      departments.each do |department|
        puts "Writing '#{department.title}' to #{department.title}.markdown..."
        puts "#{department.title}.markdown", department.to_markdown
      end
    end
  end
end
