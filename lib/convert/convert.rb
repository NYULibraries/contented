require 'hashie'
require_relative 'helpers/google_sheet'
require_relative 'helpers/md_fields'
require_relative 'helpers/yaml_maker'

module Conversion
  # Grabs data from spreadsheet and converts it into a Markdown files
  class Convert
    def initialize
      FileUtils.mkdir 'site' unless File.directory? 'site'
    end

    def make_the_markdown(sheet_num, md_of)
      Helpers::YamlMaker.create_md(sheet_num, md_of) # Worksheet 1 contains departments
    end
  end
end
