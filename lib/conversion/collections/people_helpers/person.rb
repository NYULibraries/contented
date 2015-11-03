module Conversion
  module Collections
    module PeopleHelpers
      # Edits the Peoplesync attributes to make them look like spreadsheet JSON
      class Person
        attr_accessor :netid, :employee_id, :last_name, :first_name, :primary_work_space_address, :work_phone, :email_address, :all_positions_jobs
        PEOPLESYNC_ATTR = { netid: 'NetID', employee_id: 'Employee_ID',last_name: 'Last_Name',first_name: 'First_Name', work_phone: 'Work_Phone',
                            email_address: 'Email_Address', primary_work_space_address: 'Primary_Work_Space_Address', all_positions_jobs: 'All_Positions_Jobs'
                          }

        def initialize(json_data)
          fail ArgumentError, 'None of the parameters can be nil' if json_data.nil?
          PEOPLESYNC_ATTR.each_pair { |variable, val| instance_variable_set("@#{variable}", json_data[val]) }
        end
      end
    end
  end
end
