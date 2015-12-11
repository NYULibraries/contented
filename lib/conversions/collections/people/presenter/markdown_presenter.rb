require_relative '../../helpers/presenter_helpers'

module Conversions
  module Collections
    module People
      module Presenter
        class MarkdownPresenter
          include Conversions::Collections::Helpers::PresenterHelpers
          attr_reader :person
          def initialize(person)
            @person = person
            render
          end

          def run
            render
          end

        private

          def yaml_start
            "---\n"
          end

          def subtitle
            "subtitle: '#{person.subtitle}'"
          end

          def job_title
            "job_title: '#{person.jobtitle}'"
          end

          def location
            "location: '#{person.location}'"
          end

          def space
            "space: '#{person.space}'"
          end

          def departments
            "departments: #{person.departments}"
          end

          def status
            "status: '#{person.status}'"
          end

          def expertise
            "expertise: #{person.expertise}"
          end

          def email
            "email: '#{person.email}'"
          end

          def phone
            "phone: '#{person.phone}'"
          end

          def twitter
            "twitter: '#{person.twitter}'"
          end

          def image
            "image: '#{person.image}'"
          end

          def buttons
            "buttons: #{person.buttons}"
          end

          def guides
            "guides: #{person.guides}"
          end

          def publications
            "publications: #{person.publications}"
          end

          def keywords
            "keywords: #{person.keywords}"
          end

          def title
            "title: '#{person.title}'"
          end

          def yaml_end
            "\n---\n"
          end

          def about_block
            "# About #{person.title}"
          end
        end
      end
    end
  end
end

