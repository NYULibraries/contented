require_relative 'expanded_person'
require_relative 'markdown_field_helpers'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class PersonExhibitor < ExpandedPerson

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

        def expertise
          @expertise ||= super
          @expertise = Markdown_Field_Helpers.new.listify(@expertise) if @expertise
          @expertise
        end

        def keywords
          @keywords ||= super
          @keywords = Markdown_Field_Helpers.new.listify(@keywords) if @keywords
          @keywords
        end

        def buttons
          @buttons ||= super
          @buttons = Markdown_Field_Helpers.new.instancify(@buttons) if @buttons
          @buttons
        end
      end
    end
  end
end
