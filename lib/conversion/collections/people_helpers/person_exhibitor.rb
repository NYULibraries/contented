require_relative 'expanded_person'
require 'yaml'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class PersonExhibitor < ExpandedPerson
        LOCATION_MAP_FILE = 'config/location_map.yml'

        def initialize(json_data='{}', json_data_expand='{}')
          super(json_data, json_data_expand)
        end

        def email
          # PeopleSync data has Email fro every staff member so no check for that.
          @email ||= super
          @email ||= email_address unless @email
          @email
        end

        def phone
          @phone ||= super
          if @phone.nil? && work_phone
            @phone ||= work_phone.gsub('+1 ', '').insert(-5, '-')
          end
          @phone
        end

        def location_map_file_exists?
          File.exist? LOCATION_MAP_FILE
        end

        def map_locations_file
          location_map_file_exists? ? YAML.load_file(LOCATION_MAP_FILE) : {}
        end

        def location_map
          @location_map ||= map_locations_file
        end

        def correct_job_position
          if all_positions_jobs
            # used detect instead of select because select returns an array of hashes if multiple 1's found
            @correct_job_position ||= all_positions_jobs.detect { |job| job['Is_Primary_Job'] == '1' }
          end
        end

        def jobtitle
          @jobtitle ||= super
          if @jobtitle.nil? && correct_job_position && correct_job_position['Business_Title']
            @jobtitle ||= correct_job_position['Business_Title']
          end
          @jobtitle
        end

        def departments
          @departments ||= super
          # puts correct_job_position.is_a? Array
          if @departments.nil? && correct_job_position && correct_job_position['Supervisory_Org_Name']
            @departments ||= correct_job_position['Supervisory_Org_Name'] + '('
            @departments = @departments.slice(0..(@departments.index('(') - 1)).strip
          end
          @departments
        end

        def location
          @location ||= super
          if @location.nil? && correct_job_position && correct_job_position['Position_Work_Space'] && correct_job_position['Position_Work_Space'].count('>') == 2
            @location ||= correct_job_position['Position_Work_Space'].split('>')[1].strip
          end
          @location
        end

        def space
          @space ||= super
          if @space.nil? && correct_job_position && correct_job_position['Position_Work_Space'] && correct_job_position['Position_Work_Space'].count('>') == 2
            @space ||= correct_job_position['Position_Work_Space'].split('>')[2].strip
          end
          @space
        end
      end
    end
  end
end
