require_relative 'expanded_person'
require_relative '../../helpers/markdown_presenter'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class ExpandedPersonExhibitor
        attr_accessor :expanded_person

        def initialize(expanded_person)
          @expanded_person = expanded_person
          email
          phone
          departments
        end

        def to_markdown
          MarkdownPresenter.new(expanded_person).render
        end

        private

        def phone_formatter(phone_number)
          # input = '+1 (555) 5555555'
          # output = '(555) 555-5555'
          phone_number.delete('+1 ').insert(-5, '-')
        end

        def correct_job_position
          expanded_person.all_position_jobs.each do |job|
            @correct_job_position ||= job if job['Is_Primary_Job'] == '1'
          end
        end

        def email
          expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').email = expanded_person.email_address if expanded_person.email.empty?
        end

        def phone
          expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').phone = phone_formatter(expanded_person.work_phone) if expanded_person.phone.empty?
        end

        def departments
          if expanded_person.departments.empty? && correct_job_position && correct_job_position['Supervisory_Org_Name']
            # Must return anything before the '(' if it exists
            expanded_person.instance_variable_get('@GoogleSpreadsheetPerson').departments ||= correct_job_position['Supervisory_Org_Name'].split('(')[0].strip
          end
        end
      end
    end
  end
end
