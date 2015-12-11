require_relative 'people/expanded_person_exhibitor'

module Conversions
  module Collections
    module People
      # Returns array of Net ID's of people that need to be excluded
      def people_exclude
      end

      # Creates an Array of Person objects from JSON data
      def list_peoplesync(json_data)
        JSON.parse(json_data).collect { |person| Person.new(person.to_json) }
      end

      # Creates an Array of GoogleSpreadsheetPerson objects from JSON data
      def list_people_sheet(json_data)
        JSON.parse(json_data).collect { |person| GoogleSpreadsheetPerson.new(person.to_json) }
      end

      # Finds the person matching the netid in sheet
      def find_person_sheet(people_sheet, netid)
        people_sheet.find { |person| person.netid == netid } || GoogleSpreadsheetPerson.new('{}')
      end

      def join_people_sync_sheet(peoplesync, people_sheet)
        exclude_netid = people_exclude || []
        people_merged = [] # Array of ExpandedPersonExhibitor
         # Add all Peoplesync data to people_merged
        peoplesync.each do |person_sync|
          next if exclude_netid.include? person_sync.netid
          person_sheet = find_person_sheet(people_sheet, person_sync.netid)
          people_merged << ExpandedPersonExhibitor.new(ExpandedPerson.new(person_sync, person_sheet))
          people_sheet.delete(person_sheet)
        end
        # Add remaining data from People Sheet
        people_sheet.each { |person| people_merged<<ExpandedPersonExhibitor.new(ExpandedPerson.new(Person.new('{}'), person)) }
        people_merged
      end

      def staff_directory(people_sync='[]', people_spreadsheet='[]')
        join_people_sync_sheet(list_peoplesync(people_sync), list_people_sheet(people_spreadsheet))
      end
    end
  end
end
