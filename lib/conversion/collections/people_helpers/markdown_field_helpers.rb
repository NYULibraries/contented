module Conversion
  module Collections
    module PeopleHelpers
      # Formats the Markdown fields
      class Markdown_Field_Helpers
        def listify(str)
          "\n#{str.split(';').collect { |d| " -  '#{d.strip!}'" }.join("\n")}" unless str.empty?
        end

        def instancify(str)
          "\n#{str.split(';').collect { |d| "  #{d.strip!}" }.join("\n")}" unless str.empty?
        end
      end
    end
  end
end
