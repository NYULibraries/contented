require File.expand_path('../base.rb', __FILE__)
require File.expand_path('../utilities/google_sheet.rb', __FILE__)
require File.expand_path('../helpers/department.rb', __FILE__)

module Nyulibraries
  module SiteLeaf
    module Loaders
      # Creates Deletes Updates Department Pages and Meta-fields
      class DepartmentPagePost < Base
        attr_accessor :page_id, :department

        def initialize(page_id, spreadsheet)
          if page_id.empty? || spreadsheet.empty?
            fail ArgumentError, 'Page ID and spreadsheet are required params'
          end
          @page_id = page_id
          @department = Helpers::Departments.load(Utilities::GoogleSheet.new(spreadsheet).json_data)
        end

        def create_pages
          department.each do |dept|
            dept.create_department(page_id)
          end
        end
      end
    end
  end
end
