require_relative 'department'
require_relative 'presenter/markdown_presenter'
require_relative '../helpers/markdown_field_helpers'

module Conversions
  module Collections
    module Departments
      # Parses the Department data into the required format.
      class DepartmentExhibitor
        extend Forwardable
        include Conversions::Collections::Helpers::MarkdownFieldHelpers
        def_delegators :@department, :title, :subtitle, :location, :space, :email, :phone, :twitter, :facebook, :blog, :libcal_id, :libanswers_id, :links, :classes, :image, :buttons, :keywords, :whatwedo
        attr_reader :department

        def initialize(department)
          @department = department
        end

        def to_markdown
          Presenter::MarkdownPresenter.new(self).run
        end

        def blog
          to_yaml_object(department.blog)
        end

        def classes
          to_yaml_object(department.classes)
        end

        def links
          to_yaml_object(department.links)
        end

        def buttons
          to_yaml_object(department.buttons)
        end

        def keywords
          to_yaml_list(department.keywords)
        end
      end
    end
  end
end
