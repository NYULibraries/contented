require_relative 'expanded_person'
require_relative '../../helpers/markdown_presenter'

module Conversion
  module Collections
    module PeopleHelpers
      # Parses the person data into the required format.
      class ExpandedPersonExhibitor
        ATTRIBUTES = [:about, :address, :buttons, :departments, :email, :expertise, :guides, :image,
                      :jobtitle, :keywords, :location, :netid, :phone, :space, :subtitle,
                      :title, :twitter, :publications, :work_phone, :status,
                      :email_address, :all_positions_jobs]
        attr_accessor *ATTRIBUTES

        def initialize(expanded_person)
          ATTRIBUTES.each { |attr| send("#{attr}=", expanded_person.send("#{attr}")) }
        end

        def to_markdown
          MarkdownPresenter.new(self).render
        end

        def email
          @email = @email_address if @email.to_s.empty?
        end

        def phone
          @phone = phone_formatter(@work_phone) if @phone.to_s.empty?
        end

        def departments
          if @departments.to_s.empty? && correct_job_position && correct_job_position['Supervisory_Org_Name']
            # Must return anything before the '(' if it exists
            @departments ||= department_formatter(correct_job_position['Supervisory_Org_Name'])
          end
        end

        def location_space
          if correct_job_position && correct_job_position['Position_Work_Space']
            city, location, space = correct_job_position['Position_Work_Space'].split('>')
            @location = location if @location.to_s.empty?
            @space = space if @space.to_s.empty?
          end
        end

        def location
          location_space
        end

        def jobtitle
          if @jobtitle.to_s.empty? && correct_job_position && correct_job_position['Business_Title']
            @jobtitle = correct_job_position['Business_Title']
          end
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
        end

        def correct_job_position
          @all_positions_jobs.each do |job|
            @correct_job_position ||= job if job['Is_Primary_Job'] == '1'
          end
          @correct_job_position
        end
      end
    end
  end
end
