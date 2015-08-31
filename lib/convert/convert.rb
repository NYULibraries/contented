require 'hashie'
require_relative 'helpers/google_sheet'
require_relative 'helpers/md_fields'
require_relative 'helpers/yaml_maker'

module Conversion
  # Grabs data from spreadsheet and converts it into a Markdown files
  class Convert
    def initialize
      FileUtils.mkdir 'data' unless File.directory? 'data'
    end

    def departments
      Helpers::YamlMaker.create_md(2, 'department', 'departments') # Worksheet 1 contains departments
    end

    def locations
      Helpers::YamlMaker.create_md(4, 'location', 'locations') # Worksheet 2 contains locations
    end

    def people
      Helpers::YamlMaker.create_md(6, 'people', 'people') # Worksheet 3 contains people
    end

    def services
      Helpers::YamlMaker.create_md(8, 'service', 'services') # Worksheet 4 contains services
    end

    def spaces
      Helpers::YamlMaker.create_md(10, 'space', 'spaces') # Worksheet 5 contains spaces
    end
  end
end
