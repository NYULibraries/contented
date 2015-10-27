require 'json'
require 'rest-client'
require_relative 'people_helpers/person'
require 'figs'
Figs.load

module Conversion
  module Collections
    # Combines the People data from spreasheet and JSON
    class People
      attr_accessor :spreadsheet_people, :raw_people_sheet, :location_map
      PEOPLE_EXCLUDE_FILE = 'config/people_exclude.yml'
      LOCATION_MAP_FILE = 'config/location_map.yml'

      def initialize(raw_people_sheet)
        fail ArgumentError, 'people_sheet must not be nil' unless raw_people_sheet
        @raw_people_sheet = raw_people_sheet
        @spreadsheet_people = exclude_people(raw_people_sheet)
      end

      # Add extra content from JSON to the people data from the spreadsheet
      def to_json
        @to_json = []
        spreadsheet_people.each do |person_sheet|
          person_json = find_net_id_json(person_sheet['netid']['tx'])
          if person_json
            @to_json << PeopleHelpers::Person.new(person_sheet, person_json, location_map).to_json
          else
            @to_json << person_sheet
          end
        end
        @to_json
      end

      def location_map
        @@location_map ||= map_locations_file
      end

      private

      # JSON call using RestClient to grab the Peoplesync data using their REST services
      # A simple uri call using Basic auth doesn't work
      def peoplesync_request
        RestClient::Request.new(method: :get, url: "#{ENV['PEOPLE_JSON_URL']}", user: "#{ENV['PEOPLE_JSON_USER']}", password: "#{ENV['PEOPLE_JSON_PASS']}",
                                headers: { accept: :json, content_type: :json }, timeout: 200
                               ).execute
      end

      # Peoplesync data can be troublesome thus try getting it 3 if timeout else is discarded
      # The code exits so the markdowns are not touched if peoplesync data cannot be retrieved
      def peoplesync_json
        tries ||= 3
        response = peoplesync_request
      rescue RestClient::Exception
        retry unless (tries -= 1).zero?
        puts 'People JSON retrieval failed after three tries'
        Signal.trap('EXIT') { exit 0 }
        response
      end

      def raw_json_peoplesync
        @raw_json_peoplesync ||= JSON.parse(peoplesync_json)['Report_Entry']
      end

      def net_id_exclude_file_exists?
        File.exist? PEOPLE_EXCLUDE_FILE
      end

      # Fetches people_exclude.yml which is the list of net_id's of people to omit from the site
      def exclude_net_id
        @exclude_net_id ||= YAML.load_file(PEOPLE_EXCLUDE_FILE)['people_exclude'] if net_id_exclude_file_exists?
      end

      # Removes the people to be excluded from the spreadsheet_people JSON
      def exclude_people(spreadsheet_people)
        return spreadsheet_people unless exclude_net_id
        spreadsheet_people.delete_if { |p_exclude| exclude_net_id.include? p_exclude['netid']['tx'] }
      end

      def location_map_file_exists?
        File.exist? LOCATION_MAP_FILE
      end

      def map_locations_file
        location_map_file_exists? ? YAML.load_file(LOCATION_MAP_FILE) : {}
      end

      # Find a person in PeopleSync Json data using their Net Id's
      def find_net_id_json(net_id)
        raw_json_peoplesync.find { |person| person['NetID'] == net_id }
      end
    end
  end
end
