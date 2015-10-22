require 'yaml'

module Conversion
  module ParsePeople
    # Edits the Peoplesync attributes to make them look like spreadsheet JSON
    class ParseAttrs
      LOCATION_MAP_FILE = 'config/location_map.yml'
      PHONE = { name: 'phone', peoplesync: 'Work_Phone' }
      EMAIL = { name: 'email', peoplesync: 'Email_Address' }
      ADDRESS = { name: 'address', peoplesync: 'Primary_Work_Space_Address' }
      JOB_TITLE = { name: 'jobtitle', peoplesync: 'Business_Title' }
      DEPARTMENT = { name: 'departments', peoplesync: 'Supervisory_Org_Name' }
      LOCATION = { name: 'location', peoplesync: 'Position_Work_Space' }
      SPACE = { name: 'space', peoplesync: 'Position_Work_Space' }

      def self.location_map
        map_locations = YAML.load_file(LOCATION_MAP_FILE) if File.exist? LOCATION_MAP_FILE
        @location_map ||= map_locations ? map_locations : {}
      end

      # Phone number is modified to remove +1 and add - after 6 digits but
      # if the phone number is nil then blank string is returned to avoid nil values in meta
      def self.modify_phone(phone)
        phone ? phone.gsub('+1 ', '').insert(-5, '-') : ''
      end

      # Department name are parsed from peoplesync data
      # if the department is nil then blank string is returned to avoid nil values in meta
      def self.modify_departments(department)
        department += '('
        department ? department.slice(0..(department.index('(') - 1)).strip : ''
      end

      # This method returns location from location_space or blank string if nil to avoid nil values in meta
      def self.parse_location(location_space)
        location_space ? location_space.slice(location_space.index('>')..location_space.rindex('>')).delete('>').strip : ''
      end

      # Some of the locations in peoplesync data are incorrect hence they need to corrected
      def self.map_to_location(location_space)
        location = parse_location(location_space)
        location_map[location] ? location_map[location] : location
      end

      # PeopleSync data returns location and space in it's address attribute. Method gets space
      def self.space(location_space)
        return '' if location_space && location_space.count('>') < 2
        location_space ? location_space.slice(location_space.rindex('>')..-1).delete('>').strip : ''
      end

      # Valid job position is the one which has attribute Is_Primary_Job = 1
      def self.valid_job_position(person_jobs)
        person_jobs.each { |job| return job if job['Is_Primary_Job'] == '1' }
        nil
      end

      def self.contact_info(person_found, person)
        person[PHONE[:name]]['tx'] = modify_phone(person_found[PHONE[:peoplesync]])
        person[EMAIL[:name]]['tx'] = person_found[EMAIL[:peoplesync]]
        person
      end

      def self.address_info(person_found, person)
        person[ADDRESS[:name]]['tx'] = person_found[ADDRESS[:peoplesync]]
        person
      end

      def self.location_info(person, job_position)
        person[LOCATION[:name]]['tx'] = map_to_location(job_position[LOCATION[:peoplesync]])
        person[SPACE[:name]]['tx'] = space(job_position[SPACE[:peoplesync]])
        person
      end

      def self.job_info(person, job_position)
        person[JOB_TITLE[:name]]['tx'] = job_position[JOB_TITLE[:peoplesync]]
        person[DEPARTMENT[:name]]['tx'] = modify_departments(job_position[DEPARTMENT[:peoplesync]])
        location_info(person, job_position)
      end

      def self.personnel_info(person_found, person)
        person = contact_info(person_found, person)
        valid_job_pos = valid_job_position(person_found['All_Positions_Jobs'])
        person = job_info(person, valid_job_pos) if valid_job_pos
        person
      end

      # Edit all key names and fields to match the Google Sheet Formats
      def self.correct_json_format(person_found, person)
        person['title']['tx'] = person_found['First_Name'] + ' ' + person_found['Last_Name']
        personnel_info(person_found, person)
      end
    end
  end
end
