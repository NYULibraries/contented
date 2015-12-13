require_relative 'service'
require_relative 'presenter/markdown_presenter'
require_relative '../helpers/markdown_field_helpers'

module Conversions
  module Collections
    module Services
      # Parses the person data into the required format.
      class ServiceExhibitor
        extend Forwardable
        include Conversions::Collections::Helpers::MarkdownFieldHelpers
        def_delegators :@service, :title, :location, :space, :type, :email, :phone, :twitter, :facebook, :libcal_id, :libanswers_id, :image, :services
        attr_reader :service

        def initialize(service)
          @service = service
        end

        def to_markdown
          Presenter::MarkdownPresenter.new(self).run
        end

        def departments
          to_yaml_list(service.departments)
        end

        def topics
          to_yaml_list(service.topics)
        end

        def access
          to_yaml_list(service.access)
        end

        def blog
          to_yaml_object(service.blog)
        end

        def links
          to_yaml_object(service.links)
        end

        def keywords
          to_yaml_list(service.keywords)
        end

        def buttons
          to_yaml_object(service.buttons)
        end
      end
    end
  end
end
