require 'json'
require 'hashie'
require 'open-uri'
require 'rest-client'
require 'figs'
Figs.load

module Conversion
  module Helpers
    # Combines the People data from the spreasheet and JSON
    class ParsePeople
      # people data is peoplesunc data
      # People_sheet is data from people spreadsheet
      attr_accessor :people, :people_sheet

      def initialize(sheet_url)
        @people ||= JSON.parse(people_json)['Report_Entry']
        @people_sheet ||= JSON.parse(open(sheet_url).read.gsub('"gsx$', '"').gsub('"$t"', '"tx"'))['feed']['entry']
      end

      # JSON call using RestClient to grab the Peoplesync data using their REST services as a simple uri call using Basic auth doesn't work
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

      # Edit the All_Positions_Jobs internal json Hash to become a part of the actual hash to covert the 2-layers into 1-layer.
      def redefine_json
        people.each do |person|
          person['All_Positions_Jobs'].each { |job_positions| job_positions.each_pair { |k, v| person['' + k] = v } }
          person.delete('All_Positions_Jobs')
        end
      end

      # Find a person in Json data using their Net Id's
      def find_person_json(net_id)
        people.find { |person| person['NetID'] == net_id }
      end

      # Phone number is modified to add +1 and add - after 6 numbers but if the phone number is nil then blank string is returned to avoid nil values in meta
      def modify_phone(phone)
        phone ? phone.gsub('+1 ', '').insert(-5, '-') : ''
      end

      # Department name are parsed from peoplesync data and if the department is nil then blank string is returned to avoid nil values in meta
      def modify_departments(department)
        department += '('
        department ? department.slice(0..(department.index('(') - 1)).strip : ''
      end

      # Fetches the location_map.yml file
      # Some of the locations in peoplesync data are incorrect hence they need to corrected
      # @location_map is a hashmap of the form location_map[peoplesync_incorrect_location] = correct_location
      def location_map
        @location_map ||= YAML.load_file('config/location_map.yml') if File.exist? 'config/location_map.yml'
      end


      # This method returns location from location_space or blank string if nil to avoid nil values in meta
      def parse_location(location_space)
        location_space ? location_space.slice(location_space.index('>')..location_space.rindex('>')).delete('>').strip : ''
      end

      # PeopleSync data returns location and space in it's address attribute. Method gets location
      # returns mapped locatino if location needs to be replaced using the location_map hash or the original location from peoplesync
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
        person['phone']['tx'] = modify_phone(person_found['Work_Phone'])
        person['email']['tx'] = person_found['Email_Address']
        person['address']['tx'] = person_found['Primary_Work_Space_Address']
        person['jobtitle']['tx'] = person_found['Business_Title']
        person
      end

      def location_info(person_found, person)
        person['departments']['tx'] = modify_departments(person_found['Supervisory_Org_Name'])
        person['location']['tx'] = map_to_location(person_found['Position_Work_Space'])
        person['space']['tx'] = space(person_found['Position_Work_Space'])
        person
      end

      # Edit all key names and fields to match the Google Sheet Formats
      def correct_json_format(person_found, person)
        person['title']['tx'] = person_found['First_Name'] + ';' + person_found['Last_Name']
        person = personnel_info(person_found, person)
        person = location_info(person_found, person)
        person_found.each_pair { |k, v| person['' + k.delete('_').downcase] = JSON.parse("{ \"tx\" : \"#{v}\"}") }
        person
      end

      # Add extra content from JSON to the people data from the spreadsheet
      def complete_people_data
        redefine_json
        people_complete = []
        people_sheet.each do |person|
          person_found_in_json = find_person_json(person['netid']['tx'])
          people_complete.push correct_json_format(person_found_in_json, person) if person_found_in_json
        end
        people_complete
      end
    end
  end
end
