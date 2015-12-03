require_relative 'expanded_person'
require_relative '../../helpers/markdown_presenter'
require_relative 'markdown_field_helpers'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class ExpandedPersonExhibitor

        def initialize(expanded_person)
          @expanded_person = expanded_person
          city, @location, @space = job_position['Position_Work_Space'].to_s.split('>')
        end

        def to_markdown
          MarkdownPresenter.new(self).render
        end

        def email
          @expanded_person.email.to_s.empty? ? @expanded_person.email_address : @expanded_person.email
        end

        def phone
         @expanded_person.phone.to_s.empty? ? phone_formatter(@expanded_person.work_phone) : @expanded_person.phone
        end

        def departments
          @expanded_person.departments.to_s.empty? ? department_formatter(job_position['Supervisory_Org_Name']) : Markdown_Field_Helpers.new.listify(@expanded_person.departments)
        end

        def location
          @expanded_person.location.to_s.empty? ? @location : @expanded_person.location
        end

        def space
          @expanded_person.space.to_s.empty? ? @space : @expanded_person.space
        end

        def jobtitle
          @expanded_person.jobtitle.to_s.empty? ? job_position['Business_Title'].to_s : @expanded_person.jobtitle
        end

        def subtitle
          @expanded_person.subtitle
        end

        def status
          @expanded_person.status
        end

        def expertise
           Markdown_Field_Helpers.new.listify(@expanded_person.expertise)
        end

        def twitter
          @expanded_person.twitter
        end

        def image
          @expanded_person.image
        end

        def buttons
          Markdown_Field_Helpers.new.instancify(@expanded_person.buttons)
        end

        def guides
          Markdown_Field_Helpers.new.instancify(@expanded_person.guides)
        end

        def publications
          Markdown_Field_Helpers.new.instancify(@expanded_person.publications)
        end

        def keywords
          Markdown_Field_Helpers.new.listify(@expanded_person.keywords)
        end

        def title
          @expanded_person.title
        end

        private

        # input = '+1 (555) 5555555'
        # output = '(555) 555-5555'
        def phone_formatter(phone_number)
          phone_number.to_s.empty? ? '' : phone_number.delete('+1 ').insert(-5, '-')
        end

        # input = 'Department Name (something)' or 'Department Name'
        # output = 'Department Name'
        def department_formatter(department_name)
          department_name.to_s.split('(')[0].strip
        end

        def job_position
          if @expanded_person.all_positions_jobs
            @job_position ||=  @expanded_person.all_positions_jobs.find { |job| job['Is_Primary_Job'] == '1' } || {}
          else
            @job_position ||= {}
          end
        end
      end
    end
  end
end
