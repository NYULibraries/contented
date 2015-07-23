require File.expand_path('../../base.rb', __FILE__)
require File.expand_path('../ia_yaml_loader.rb', __FILE__)
require File.expand_path('../core_helpers.rb', __FILE__)
module Nyulibraries
  module SiteLeaf
    module Loaders
      module Helpers
        # Creates Deletes Updates Department Pages and Meta-fields
        class Department
          attr_accessor :data

          def initialize(data)
            fail ArgumentError, 'data is a required param' if data.empty?
            @data = data
          end

          def hierarchial_architecture
            IAYamlLoader.new('lib/loaders/config/departmentIA.yml')
          end

          def helpers
            CoreHelpers.new(data)
          end

          def create_or_update_department(parent_id)
            ia = hierarchial_architecture
            helper = helpers
            page_exists = helper.find_subpage(parent_id, helper.get_data_elements(ia.page.title))
            return helper.update_subpage_posts(ia, page_exists) if page_exists
            page_id = helper.create_subpage(parent_id, ia.page)
            helper.create_posts(page_id, ia.posts)
          end

          def delete_department(parent_id)
            ia = hierarchial_architecture
            helpers.delete_subpage(parent_id, ia.page.title)
          end
        end
        # Creates Departments object array
        class Departments
          extend Enumerable
          def self.load(google_spreadsheet)
            department = []
            google_spreadsheet.each { |line| department << Department.new(line) }
            department
          end
        end
      end
    end
  end
end
