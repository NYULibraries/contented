module Conversion
  module Collections
    module PeopleHelpers
      # Formats the Markdown fields
      class Markdown_Field_Helpers
        def strip_spaces_in_between(element, char)
          element.gsub(/\s+#{char}/, "#{char}").gsub(/#{char}\s+/, "#{char}")
        end

        def listify(element)
          return '' if element.empty?
          element = strip_spaces_in_between(element, ';') # Replace ; with new line and - for list in Yaml
          "\n  - '" + element.gsub(';', "'\n  - '") + "'"
        end

        def instancify(element)
          return '' if element.empty?
          element = strip_spaces_in_between(element, ';') # Replace ; with new line and - for list in Yaml
          "\n  " + element.gsub(';', "\n  ")
        end
      end
    end
  end
end
