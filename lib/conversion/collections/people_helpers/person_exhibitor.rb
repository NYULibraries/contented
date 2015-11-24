require_relative 'expanded_person'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class PersonExhibitor < ExpandedPerson

        def initialize(json_data='{}', json_data_expand='{}')
          super(json_data, json_data_expand)
        end

        def parse_email
          # PeopleSync data has Email fro every staff member so no check for that.
          @email ||= email_address unless @email
        end

        def parse_phone
          if @phone.nil? && work_phone
            @phone = work_phone.gsub('+1 ', '').insert(-5, '-')
          end
        end

        def correct_job_position
          @correct_job_position ||= all_positions_jobs.select { |job| job['Is_Primary_Job'] == '1' }
        end

        def parse_job_title
          if @jobtitle.nil? && @correct_job_position['Business_Title']
            @jobtitle = @correct_job_position['Business_Title']
          end
        end

        def parse_departments
          if @departments.nil? && @correct_job_position['Supervisory_Org_Name']
            @departments = @correct_job_position['Supervisory_Org_Name'] + '('
            @departments = @departments.slice(0..(@departments.index('(') - 1)).strip
          end
        end

        def parse_location
          if @location.nil? && @correct_job_position['Position_Work_Space'] && @correct_job_position['Position_Work_Space'].count('>') == 2
            @location = @correct_job_position['Position_Work_Space'].split('>')[1].strip
          end
        end

        def parse_space
          if @space.nil? && @correct_job_position['Position_Work_Space'] && @correct_job_position['Position_Work_Space'].count('>') == 2
            @space = @correct_job_position['Position_Work_Space'].split('>')[2].strip
          end
        end
      end
    end
  end
end
