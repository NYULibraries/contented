require_relative '../../helpers/presenter_helpers'

module Conversions
  module Collections
    module Departments
      module Presenter
        class MarkdownPresenter
          include Conversions::Collections::Helpers::PresenterHelpers
          attr_reader :department
          def initialize(department)
            @department = department
          end

          def run
            render
          end

        private

          def yaml_start
            "---\n"
          end

          def title
            "title: '#{department.title}'"
          end

          def subtitle
            "subtitle: '#{department.subtitle}'"
          end

          def location
            "location: '#{department.location}'"
          end

          def space
            "space: '#{department.space}'"
          end

          def email
            "email: '#{department.email}'"
          end

          def phone
            "phone: '#{department.phone}'"
          end

          def twitter
            "twitter: '#{department.twitter}'"
          end

          def facebook
            "facebook: '#{department.facebook}'"
          end

          def blog
            "blog: #{department.blog}"
          end

          def libcal_id
            "libcal_id: '#{department.libcal_id}'"
          end

          def libanswers_id
            "libanswers_id: '#{department.libanswers_id}'"
          end

          def links
            "links: #{department.links}"
          end

          def classes
            "classes: #{department.classes}"
          end

          def image
            "image: '#{department.image}'"
          end

          def keywords
            "keywords: #{department.keywords}"
          end

          def yaml_end
            "\n---\n"
          end

          def whatwedo
            "# What We Do\n#{department.whatwedo}"
          end
        end
      end
    end
  end
end

