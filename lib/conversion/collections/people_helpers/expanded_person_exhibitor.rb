require_relative 'expanded_person'
require_relative '../../helpers/markdown_presenter'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class ExpandedPersonExhibitor
        def initialize(expanded_person)
          @expanded_person = expanded_person
          email
          phone
          departments
          location_space
          jobtitle
        end

        def to_markdown
          MarkdownPresenter.new(@expanded_person).render
        end

        private

        def phone_formatter(phone_number)
          # input = '+1 (555) 5555555'
          # output = '(555) 555-5555'
          phone_number.delete('+1 ').insert(-5, '-')
        end

        def department_formatter(department_name)
          # input = 'Department Name (something)' or 'Department Name'
          # output = 'Department Name'
          department_name.split('(')[0].strip

        def correct_job_position
          @expanded_person.all_positions_jobs.each do |job|
            @correct_job_position ||= job if job['Is_Primary_Job'] == '1'
          end
          @correct_job_position
        end

        def email
          @expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').email = @expanded_person.email_address if @expanded_person.email.to_s.empty?
        end

        def phone
          @expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').phone = phone_formatter(@expanded_person.work_phone) if @expanded_person.phone.to_s.empty?
        end

        def departments
          if @expanded_person.departments.to_s.empty? && correct_job_position && correct_job_position['Supervisory_Org_Name']
            # Must return anything before the '(' if it exists
            @expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').departments ||= department_formatter(correct_job_position['Supervisory_Org_Name'])
          end
        end

        def location_space
          if correct_job_position && correct_job_position['Position_Work_Space']
            city, location, space = correct_job_position['Position_Work_Space'].split('>')
            @expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').location = location if @expanded_person.location.to_s.empty?
            @expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').space = space if @expanded_person.space.to_s.empty?
          end
        end

        def jobtitle
          if @expanded_person.jobtitle.to_s.empty? && correct_job_position && correct_job_position['Business_Title']
            @expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').jobtitle = correct_job_position['Business_Title']
          end
        end
      end
    end
  end
end
