require_relative 'departments/department_exhibitor'

module Conversions
  module Collections
    # Creates an Array of Department objects from JSON data
    module Departments
      def departments(json_data)
        JSON.parse(json_data).collect { |department| DepartmentExhibitor.new(Department.new(department.to_json)) }
      end
    end
  end
end
