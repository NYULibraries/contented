require 'yaml'
# require_relative '../people'

module Conversion
  module Collections
    module PeopleHelpers
      # Edits the Peoplesync attributes to make them look like spreadsheet JSON
      class Person
        attr_accessor :title, :phone, :email, :address, :jobtitle, :departments, :location, :space
        PEOPLESYNC_ATTR = { phone: 'Work_Phone', email: 'Email_Address', address: 'Primary_Work_Space_Address', jobtitle: 'Business_Title',
                            departments: 'Supervisory_Org_Name', location: 'Position_Work_Space', space: 'Position_Work_Space' }

        def initialize(sheet_person, json_person, location_map)
          fail ArgumentError, 'None of the parameters can be nil' if sheet_person.nil? || json_person.nil? || location_map.nil?
          @@sheet_person = sheet_person
          @@json_person = json_person
          @@location_map = location_map
          @to_json = sheet_person
        end

        def to_json
          call_all_setter_functions
          instance_variables.collect { |var| @to_json[var.to_s.delete('@')]['tx'] = instance_variable_get(var) unless var.to_s == '@to_json' }
          @to_json
        end

        def title
          @title ||= @@json_person['First_Name'] + ' ' + @@json_person['Last_Name']
        end

        def phone
          @phone ||= modify_phone(@@json_person[PEOPLESYNC_ATTR[:phone]])
        end

        def email
          @email ||= @@json_person[PEOPLESYNC_ATTR[:email]]
        end

        def address
          @address ||= @@json_person[PEOPLESYNC_ATTR[:address]]
        end

        def jobtitle
          @jobtitle ||= parse_job_title
        end

        def departments
          @departments ||= modify_departments(valid_job_position(@@json_person['All_Positions_Jobs'])[PEOPLESYNC_ATTR[:departments]])
        end

        def location
          @location ||= map_to_location(valid_job_position(@@json_person['All_Positions_Jobs'])[PEOPLESYNC_ATTR[:location]])
        end

        def space
          @space ||= parse_space(valid_job_position(@@json_person['All_Positions_Jobs'])[PEOPLESYNC_ATTR[:space]])
        end

        # Phone number is modified to remove +1 and add - after 6 digits but
        # if the phone number is nil then blank string is returned to avoid nil values in meta
        def modify_phone(phone)
          phone ? phone.gsub('+1 ', '').insert(-5, '-') : ''
        end

        # Department name are parsed from peoplesync data
        # if the department is nil then blank string is returned to avoid nil values in meta
        def modify_departments(department)
          department += '(' if department
          department ? department.slice(0..(department.index('(') - 1)).strip : ''
        end

        # This method returns location from location_space or blank string if nil to avoid nil values in meta
        def parse_location(location_space)
          location_space ? location_space.slice(location_space.index('>')..location_space.rindex('>')).delete('>').strip : ''
        end

        # Some of the locations in peoplesync data are incorrect hence they need to corrected
        def map_to_location(location_space)
          location = parse_location(location_space)
          @@location_map[location] ? @@location_map[location] : location
        end

        # PeopleSync data returns location and space in it's address attribute. Method gets space
        def parse_space(location_space)
          return '' if location_space && location_space.count('>') < 2
          location_space ? location_space.slice(location_space.rindex('>')..-1).delete('>').strip : ''
        end

        # Valid job position is the one which has attribute Is_Primary_Job = 1
        def valid_job_position(person_jobs)
          person_jobs.each { |job| return job if job['Is_Primary_Job'] == '1' }
          {}
        end

        def parse_job_title
          valid_job_pos = valid_job_position(@@json_person['All_Positions_Jobs'])
          return '' unless valid_job_pos
          valid_job_pos[PEOPLESYNC_ATTR[:jobtitle]] ? valid_job_pos[PEOPLESYNC_ATTR[:jobtitle]] : ''
        end

        private

        def call_all_setter_functions
          PEOPLESYNC_ATTR.each_pair { |key, _val| send(key) }
        end
      end
    end
  end
end
