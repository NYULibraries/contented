module Contented
  module Conversions
    module Collections
      module People
        module Presenters
          # Presenter class for Expanded Person Exhibitor. Lists all items in People Markdown
          class MarkdownPresenter
            include Conversions::Collections::Helpers::PresenterHelpers
            attr_reader :person
            def initialize(person)
              @person = person
            end

            private

            def yaml_start
              "---\n"
            end

            def subtitle
              "subtitle: #{wrap_in_quotes(person.subtitle)}"
            end

            def job_title
              "job_title: #{wrap_in_quotes(person.jobtitle)}"
            end

            def location
              "location: #{wrap_in_quotes(person.location)}"
            end

            def space
              "space: #{wrap_in_quotes(person.space)}"
            end

            def departments
              "departments: #{person.departments}"
            end

            def status
              "status: #{wrap_in_quotes(person.status)}"
            end

            def expertise
              "expertise: #{person.expertise}"
            end

            def email
              "email: #{wrap_in_quotes(person.email)}"
            end

            def phone
              "phone: #{wrap_in_quotes(person.phone)}"
            end

            def twitter
              "twitter: #{wrap_in_quotes(person.twitter)}"
            end

            def image
              "image: #{wrap_in_quotes(person.image)}"
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

            def blog
              "blog: #{person.blog}"
            end

            def keywords
              "keywords: #{person.keywords}"
            end

            def title
              "title: #{wrap_in_quotes(person.title)}"
            end

            def yaml_end
              "\n---\n"
            end

            def about_block
              "# About #{person.title}\n\n#{person.about}" unless person.about == '' || person.about.nil?
            end

            def wrap_in_quotes(raw=nil)
              "'#{raw.gsub(/'/,'\'\'')}'" unless raw.nil? || raw == ''
            end
          end
        end
      end
    end
  end
end