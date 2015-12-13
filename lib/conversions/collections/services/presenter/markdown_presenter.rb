require_relative '../../helpers/presenter_helpers'

module Conversions
  module Collections
    module Services
      module Presenter
        class MarkdownPresenter
          include Conversions::Collections::Helpers::PresenterHelpers
          attr_reader :service
          def initialize(service)
            @service = service
          end

          def run
            render
          end

        private

          def yaml_start
            "---\n"
          end

          def subtitle
            "title: '#{service.title}'"
          end

          def location
            "location: '#{service.location}'"
          end

          def space
            "space: '#{service.space}'"
          end

          def departments
            "departments: #{service.departments}"
          end

          def topics
            "topics: #{service.topics}"
          end

          def access
            "access: #{service.access}"
          end

          def email
            "email: '#{service.email}'"
          end

          def phone
            "phone: '#{service.phone}'"
          end

          def twitter
            "twitter: '#{service.twitter}'"
          end

          def blog
            "blog: #{service.blog}"
          end

          def libcal_id
            "libcal_id: '#{service.libcal_id}'"
          end

          def libanswers_id
            "libanswers_id: '#{service.libanswers_id}'"
          end

          def links
            "links: #{service.links}"
          end

          def image
            "image: '#{service.image}'"
          end

          def keywords
            "keywords: #{service.keywords}"
          end

          def buttons
            "buttons: #{service.buttons}"
          end

          def type
            "type: '#{service.type}'"
          end

          def yaml_end
            "\n---\n"
          end

          def services
            "# About #{service.title}\n#{service.services}"
          end
        end
      end
    end
  end
end

