module Contented
  module Conversions
    module Collections
      module People
        module Presenters
          # Presenter class for Expanded Person Exhibitor. Lists all items in People Markdown
          class MarkdownPresenter
            include Conversions::Collections::Helpers::PresenterHelpers
            include Conversions::Collections::Helpers::MarkdownFieldHelpers
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

            def library
              "library: #{wrap_in_quotes(person.library)}"
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

            def subject_specialties
              yaml_remove_start({"subject_specialties" => YAML.load(person.subject_specialties)}.to_yaml).strip
            end

            def liaisonrelationship
              "liaison_relationship: #{person.liaisonrelationship}"
            end

            def linkedin
              "linkedin: #{person.linkedin}"
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
              "#{person.about}" unless person.about == '' || person.about.nil?
            end
          end
        end
      end
    end
  end
end
