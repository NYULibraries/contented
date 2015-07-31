require 'hashie'
require_relative 'helpers/google_sheet'
require_relative 'helpers/md_fields'
require_relative 'helpers/yaml_maker'

# Grabs data from spreadsheet and converts it into a Markdown files
class Convert
  def initialize
    FileUtils.mkdir 'data' unless File.directory? 'data'
    FileUtils.cp 'bin/config/README.md', 'data'
    FileUtils.cp 'bin/config/.gitignore', 'data'
  end

  def departments
    YamlMaker.create_md(1, 'department', 'departments') # Worksheet 1 contains departments
  end

  def locations
    YamlMaker.create_md(2, 'location', 'locations') # Worksheet 2 contains locations
  end

  def people
    YamlMaker.create_md(3, 'people', 'people') # Worksheet 3 contains people
  end

  def services
    YamlMaker.create_md(4, 'service', 'services') # Worksheet 4 contains services
  end

  def spaces
    YamlMaker.create_md(5, 'space', 'spaces') # Worksheet 5 contains spaces
  end
end
