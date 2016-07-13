module Contented
  module Conversions
    module Collections
      module People
        # Parses the person data into the required format.
        class ExpandedPersonExhibitor
          extend Forwardable
          include Conversions::Collections::Helpers::MarkdownFieldHelpers
          def_delegators :@expanded_person, :subtitle, :status, :twitter, :image, :about, :parentdepartment
          attr_reader :expanded_person

          def initialize(expanded_person)
            @expanded_person = expanded_person
            @job_position ||= @expanded_person.all_positions_jobs.find { |job| job['Is_Primary_Job'] == '1' } || {}
            _city, @location, @space = @job_position['Position_Work_Space'].to_s.split('>')
          end

          def to_markdown
            Presenters::MarkdownPresenter.new(self).render
          end

          def title
            return "#{expanded_person.title}" if first_name.nil? || last_name.nil?
             "#{first_name} #{last_name}"
          end

          def first_name
            expanded_person.firstname || expanded_person.first_name
          end

          def last_name
            expanded_person.lastname || expanded_person.last_name
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
            location_formatter(expanded_person.location) || location_formatter(@location)
          end

          def space
            space = expanded_person.space || @space
            space.strip unless space.nil?
          end

          def jobtitle
            expanded_person.jobtitle || @job_position['Business_Title']
          end

          def subjectspecialties
            YAML.load(expanded_person.subjectspecialties).to_yaml[4...-1] unless expanded_person.subjectspecialties.empty?
          rescue
            expanded_person.subjectspecialties
          end

          def liaisonrelationship
            to_yaml_list(expanded_person.liaisonrelationship)
          end

          def linkedin
            to_yaml_list(expanded_person.linkedin)
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

          def blog
            to_yaml_object(expanded_person.blog)
          end

          def keywords
            to_yaml_list(expanded_person.keywords)
          end

          private

          # input = '+1 (555) 5555555'
          # output = '(555) 555-5555'
          def phone_formatter(phone_number)
            phone_number.gsub('+1 ', '').insert(-5, '-') if phone_number
          end

          # input = 'Department Name (something)' or 'Department Name'
          # output = 'Department Name'
          def department_formatter(department_name)
            department_name.split('(')[0].strip if department_name
          end

          def location_formatter(location_name)
            unless location_name.nil?
              location_map[location_name.strip] || location_name.strip
            end
          end

          def location_map
            @location_map ||= YAML.load(File.read(File.join(File.dirname(__FILE__), '../../../../../','config/location_map.yml')))
          end
        end
      end
    end
  end
end
