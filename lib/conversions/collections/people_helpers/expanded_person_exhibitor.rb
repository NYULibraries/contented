require 'forwardable'
require_relative 'expanded_person'
require_relative '../../helpers/markdown_presenter'
require_relative '../../helpers/markdown_field_helpers/markdown_field_helpers'

module Conversions
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class ExpandedPersonExhibitor
        extend Forwardable
        include MarkdownFieldHelpers
        def_delegators :@expanded_person, :subtitle, :status, :twitter, :twitter, :image, :title
        attr_reader :expanded_person

        def initialize(expanded_person)
          @expanded_person = expanded_person
          @job_position ||=  @expanded_person.all_positions_jobs.find { |job| job['Is_Primary_Job'] == '1' } || {}
          city, @location, @space = @job_position['Position_Work_Space'].to_s.split('>')
        end

        def to_markdown
          MarkdownPresenter.new(self).render
        end

        def email
          expanded_person.email || expanded_person.email_address
        end

        def phone
         expanded_person.phone || phone_formatter(expanded_person.work_phone)
        end

        def departments
          to_yaml_list(expanded_person.departments) || department_formatter(@job_position['Supervisory_Org_Name'])
        end

        def location
          expanded_person.location || @location
        end

        def space
          expanded_person.space || @space
        end

        def jobtitle
          expanded_person.jobtitle || @job_position['Business_Title']
        end

        def expertise
           to_yaml_list(expanded_person.expertise)
        end

        def buttons
          to_yaml_object(expanded_person.buttons)
        end

        def guides
          to_yaml_object(expanded_person.guides)
        end

        def publications
          to_yaml_object(expanded_person.publications)
        end

        def keywords
          to_yaml_list(expanded_person.keywords)
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
      end
    end
  end
end
