require 'json'

module Conversion
  module Collections
    module PeopleHelpers
      # Edits the Peoplesync attributes to make them look like spreadsheet JSON
      class Person
        attr_accessor :netid, :employee_id, :last_name, :first_name, :primary_work_space_address, :work_phone, :email_address, :all_positions_jobs

        def initialize(json_data)
          fail ArgumentError, 'None of the parameters can be nil' if json_data.nil?
          JSON.parse(json_data)['Report_Entry'][0].each_pair { |k,v| instance_variable_set("@#{k.downcase}", v) if respond_to?(k.downcase) } if valid_json? json_data
        end

        def valid_json?(json_data)
            JSON.parse(json_data)
            return true
          rescue Exception => e
            # puts 'Incorrect JSON FORMAT'
            return false
        end
      end
    end
  end
end
