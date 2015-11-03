require 'json'

module Conversion
  module Collections
    module PeopleHelpers
      # Edits the Peoplesync attributes to make them look like spreadsheet JSON
      class Person
        attr_accessor :netid, :employee_id, :last_name, :first_name, :primary_work_space_address, :work_phone, :email_address, :all_positions_jobs

        def initialize(json_data)
            JSON.parse(json_data).each_pair { |var, val| send("#{var.downcase}=", val) if respond_to?(var.downcase) }
          rescue Exception => e
            # do nothing
        end
      end
    end
  end
end
