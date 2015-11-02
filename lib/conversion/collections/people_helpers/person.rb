module Conversion
  module Collections
    module PeopleHelpers
      # Edits the Peoplesync attributes to make them look like spreadsheet JSON
      class Person
        attr_accessor :netid, :employee_id, :last_name, :first_name, :primary_work_space_address, :work_phone, :email_address, :all_positions_jobs
        PEOPLESYNC_ATTR = { netid: 'NetID', employee_id: 'Employee_ID',last_name: 'Last_Name',first_name: 'First_Name', phone: 'Work_Phone',
                            email: 'Email_Address', address: 'Primary_Work_Space_Address', all_positions_jobs: 'All_Positions_Jobs'
                          }

        def initialize(json_data)
          fail ArgumentError, 'None of the parameters can be nil' if json_data.nil?
          @json_data = json_data
        end

        def netid
          @employee_id ||= @json_data[PEOPLESYNC_ATTR[:netid]]
        end

        def employee_id
          @netid ||= @json_data[PEOPLESYNC_ATTR[:employee_id]]
        end

        def last_name
          @last_name ||= @json_data[PEOPLESYNC_ATTR[:last_name]]
        end

        def first_name
          @first_name ||= @json_data[PEOPLESYNC_ATTR[:first_name]]
        end

        def primary_work_space_address
          @primary_work_space_address ||= @json_data[PEOPLESYNC_ATTR[:address]]
        end

        def work_phone
          @work_phone ||= @json_data[PEOPLESYNC_ATTR[:phone]]
        end

        def email_address
          @email_address ||= @json_data[PEOPLESYNC_ATTR[:email]]
        end

        def all_positions_jobs
          @all_positions_jobs ||= @json_data[PEOPLESYNC_ATTR[:all_positions_jobs]]
        end
      end
    end
  end
end