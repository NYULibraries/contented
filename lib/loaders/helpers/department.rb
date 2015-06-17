require File.expand_path('../../base.rb', __FILE__)
module Nyulibraries
  module SiteLeaf
    module Helpers
      # Creates Deletes Updates Department Pages and Meta-fields
      class Department
        attr_accessor :data, :parent_id

        def initialize(data)
          fail ArgumentError, 'data is a required param' if data.empty?
          @data = data
        end

        def create_department(page_id)
          # Creates page for a department
          # department_page_id =
          make_page(page_id).id
        end

        def make_page(page_id)
          # Creates page for a department
          Loaders::Base.new.create_page(
            parent_id:  page_id,
            title:      title
          )
        end

        def make_post(subpage_id, post_title, body)
          # Creates posts under the new department subpage in Siteleaf
          Loaders::Base.new.create_post(
            parent_id:  subpage_id,
            title:      post_title,
            body:       body
          )
        end

        def title
          # get title form the data which is the departmentname
          data.departmentname.t
        end
      end

      # Creates Departments object array
      class Departments
        extend Enumerable
        def self.load(google_spreadsheet)
          department = []
          google_spreadsheet.each do |line|
            department << Department.new(line)
          end
          department
        end
      end
    end
  end
end
