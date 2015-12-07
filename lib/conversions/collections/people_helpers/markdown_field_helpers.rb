module Conversion
  module Collections
    module PeopleHelpers
      # Formats the Markdown fields
      class Markdown_Field_Helpers
        def listify(semicolon_seperated)
          "\n#{semicolon_seperated.split(';').collect { |item| " -  '#{item.strip}'" }.join("\n")}" unless semicolon_seperated.empty?
        end

        def instancify(semicolon_seperated)
          "\n#{semicolon_seperated.split(';').collect { |item| "  #{item.strip}" }.join("\n")}" unless semicolon_seperated.empty?
        end
      end
    end
  end
end
