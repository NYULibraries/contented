require 'json'
require 'hashie'
require 'open-uri'
require 'rest-client'
require 'figs'
Figs.load

module Conversion
  module Helpers
    # Combines the People data from spreasheet and JSON
    class ParsePeople
      attr_accessor :peoplesync, :spreadsheet_people, :location_map
      PEOPLE_EXCLUDE_FILE = 'config/people_exclude.yml'
      LOCATION_MAP_FILE = 'config/location_map.yml'
      PHONE = { name: 'phone', peoplesync: 'Work_Phone' }
      EMAIL = { name: 'email', peoplesync: 'Email_Address' }
      ADDRESS = { name: 'address', peoplesync: 'Primary_Work_Space_Address' }
      JOB_TITLE = { name: 'jobtitle', peoplesync: 'Business_Title' }
      DEPARTMENT = { name: 'departments', peoplesync: 'Supervisory_Org_Name' }
      LOCATION = { name: 'location', peoplesync: 'Position_Work_Space' }
      SPACE = { name: 'space', peoplesync: 'Position_Work_Space' }

      def initialize(spreadsheet_url)
        fail ArgumentError, 'spreadsheet_url must not be nil' unless spreadsheet_url
        @spreadsheet_people ||= people_sheet_after_exclusion(spreadsheet_url)
      end

      def peoplesync
        @peoplesync ||= JSON.parse(people_json)['Report_Entry']
      end

      # People to be excluded are removed from the raw worksheet data itself.
      def people_sheet_after_exclusion(spreadsheet_url)
        exclude_people(JSON.parse(open(spreadsheet_url).read.gsub('"gsx$', '"').gsub('"$t"', '"tx"'))['feed']['entry'])
      end

      # Fetches people_exclude.yml which is the list of net_id's of people to omit from the site
      def people_exclude
        @people_exclude ||= YAML.load_file(PEOPLE_EXCLUDE_FILE)['people_exclude'] if File.exist? PEOPLE_EXCLUDE_FILE
      end

      # Removes the people to be excluded from the spreadsheet_people JSON
      def exclude_people(spreadsheet_people)
        people_exclude ? spreadsheet_people.delete_if { |p_exclude| people_exclude.include? p_exclude['netid']['tx'] } : spreadsheet_people
      end

      # JSON call using RestClient to grab the Peoplesync data using their REST services
      # A simple uri call using Basic auth doesn't work
      def people_json_call
        RestClient::Request.new(method: :get, url: "#{ENV['PEOPLE_JSON_URL']}", user: "#{ENV['PEOPLE_JSON_USER']}", password: "#{ENV['PEOPLE_JSON_PASS']}",
                                headers: { accept: :json, content_type: :json }, timeout: 200
                               ).execute
      end

      # Peoplesync data can be troublesome thus try getting it 3 if timeout else is discarded
      # The code exits so the markdowns are not touched if peoplesync data cannot be retrieved
      def people_json
        tries ||= 3
        response = people_json_call
      rescue RestClient::Exception
        retry unless (tries -= 1).zero?
        puts 'People JSON retrieval failed after three tries'
        Signal.trap('EXIT') { exit 0 }
        response
      end

      # to Convert the 2-layers Peoplesync Hash into 1-layer.
      def redefine_json
        peoplesync.each do |person|
          person['All_Positions_Jobs'].each { |job_positions| job_positions.each_pair { |k, v| person['' + k] = v } }
          person.delete('All_Positions_Jobs')
        end
      end

      # Find a person in PeopleSync Json data using their Net Id's
      def find_person_json(net_id)
        peoplesync.find { |person| person['NetID'] == net_id }
      end

      # Phone number is modified to remove +1 and add - after 6 digits but
      # if the phone number is nil then blank string is returned to avoid nil values in meta
      def modify_phone(phone)
        phone ? phone.gsub('+1 ', '').insert(-5, '-') : ''
      end

      # Department name are parsed from peoplesync data
      # if the department is nil then blank string is returned to avoid nil values in meta
      def modify_departments(department)
        department += '('
        department ? department.slice(0..(department.index('(') - 1)).strip : ''
      end

      # Fetches the location_map.yml file if it exists otherwise it returns empty {} to avoid nil
      def location_map
        map_locations = YAML.load_file(LOCATION_MAP_FILE) if File.exist? LOCATION_MAP_FILE
        @location_map =  map_locations ? map_locations : {}
      end

      # This method returns location from location_space or blank string if nil to avoid nil values in meta
      def parse_location(location_space)
        location_space ? location_space.slice(location_space.index('>')..location_space.rindex('>')).delete('>').strip : ''
      end

      # Some of the locations in peoplesync data are incorrect hence they need to corrected
      def map_to_location(location_space)
        location = parse_location(location_space)
        location_map[location] ? location_map[location] : location
      end

      # PeopleSync data returns location and space in it's address attribute. Method gets space
      def space(location_space)
        return '' if location_space && location_space.count('>') < 2
        location_space ? location_space.slice(location_space.rindex('>')..-1).delete('>').strip : ''
      end

      def personnel_info(person_found, person)
        person[PHONE[:name]]['tx'] = modify_phone(person_found[PHONE[:peoplesync]])
        person[EMAIL[:name]]['tx'] = person_found[EMAIL[:peoplesync]]
        person[ADDRESS[:name]]['tx'] = person_found[ADDRESS[:peoplesync]]
        person[JOB_TITLE[:name]]['tx'] = person_found[JOB_TITLE[:peoplesync]]
        person[DEPARTMENT[:name]]['tx'] = modify_departments(person_found[DEPARTMENT[:peoplesync]])
        person[LOCATION[:name]]['tx'] = map_to_location(person_found[LOCATION[:peoplesync]])
        person[SPACE[:name]]['tx'] = space(person_found[SPACE[:peoplesync]])
        person
      end

      # Edit all key names and fields to match the Google Sheet Formats
      def correct_json_format(person_found, person)
        person['title']['tx'] = person_found['First_Name'] + ';' + person_found['Last_Name']
        person = personnel_info(person_found, person)
        person_found.each_pair { |k, v| person['' + k.delete('_').downcase] = JSON.parse("{ \"tx\" : \"#{v}\"}") }
        person
      end

      # Add extra content from JSON to the people data from the spreadsheet
      def complete_people_data
        redefine_json
        people_complete = []
        spreadsheet_people.each do |person|
          person_found_in_json = find_person_json(person['netid']['tx'])
          people_complete.push correct_json_format(person_found_in_json, person) if person_found_in_json
        end
        people_complete
      end
    end
  end
end
