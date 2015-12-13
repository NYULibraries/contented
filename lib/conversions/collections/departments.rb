require_relative 'departments/department_exhibitor'

module Conversions
  module Collections
    module Departments
      # Creates an Array of Department objects from JSON data
      def departments(json_data)
        JSON.parse(json_data).collect { |service| DepartmentExhibitor.new(Department.new(service.to_json)) }
      end
    end
  end
end
