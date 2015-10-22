require 'json'
require 'hashie'
require 'open-uri'
require 'rest-client'
require_relative 'parse_attrs'
require 'figs'
Figs.load

module Conversion
  module ParsePeople
    # Combines the People data from spreasheet and JSON
    class MergePeople
      attr_accessor :peoplesync, :spreadsheet_people
      PEOPLE_EXCLUDE_FILE = 'config/people_exclude.yml'

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

      # Find a person in PeopleSync Json data using their Net Id's
      def find_person_json(net_id)
        peoplesync.find { |person| person['NetID'] == net_id }
      end

      # Add extra content from JSON to the people data from the spreadsheet
      def complete_people_data
        people_complete = []
        spreadsheet_people.each do |person|
          person_found_in_json = find_person_json(person['netid']['tx'])
          people_complete.push ParseAttrs.correct_json_format(person_found_in_json, person) if person_found_in_json
        end
        people_complete
      end
    end
  end
end
