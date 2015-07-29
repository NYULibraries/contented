require 'open-uri'
require 'hashie'
require 'json'
require 'figs'
Figs.load

# Grabs data from spreadsheet and converts it into a Markdown files
class Convert
  def initialize
    FileUtils.mkdir 'data' unless File.directory? 'data'
    FileUtils.cp 'bin/config/README.md', 'data'
    FileUtils.cp 'bin/config/.gitignore', 'data'
  end

  def uri(sheet_num)
    "http://spreadsheets.google.com/feeds/list/#{ENV['GOOGLE_SHEET_KEY']}/#{sheet_num}/public/values?alt=json"
  end

  def sheet(sheet_num)
    # Making objects of json file generated from spreadsheet and Remove gsx$ and $t from column and cell names
    Hashie::Mash.new(JSON.parse(open(uri(sheet_num)).read.gsub('"gsx$', '"').gsub('"$t"', '"t"'))).feed.entry
  end

  def strip_spaces_in_between(string, char)
    string.gsub(/\s+#{char}/, "#{char}").gsub(/#{char}\s+/, "#{char}")
  end

  def listify(element)
    return '' if element.empty?
    element = strip_spaces_in_between(element, ';') # Replace ; with new line and - for list in Yaml
    "\n  - \"" + element.gsub(';', "\"\n  - \"") + "\""
  end

  def listify_assets(asset)
    return '' if asset.empty?
    asset = strip_spaces_in_between(asset, ';')
    asset = strip_spaces_in_between(asset, '>')
    "\n  - path: \"" + asset.gsub(';', "\"\n  - path: \"").gsub('>', "\"\n    name: \"") + "\""
  end

  def break_address_2_lines(address)
    return '' if address.empty?
    "\n  \"" + address.sub(',', "\n  ") + "\""
  end

  def slugify(slug_name)
    # Strip according to the mode, Remove leading/trailing hyphen and downcase
    slug_name.gsub(/[^[:alnum:]]+/, '-').gsub(/^\-|\-$/i, '').downcase
  end

  def yaml_load(structure)
    Hashie::Mash.new(YAML.load_file('bin/config/' + structure + '.yml'))
  end

  def convert_to_column_names(name)
    name.gsub('_', '').gsub(' ', '').downcase
  end

  def asset(data, key)
    key + ':' + listify_assets(data.send(convert_to_column_names(key)).t) + "\n"
  end

  def list(data, key, val)
    return key + ':' + listify(data.send(convert_to_column_names(key)).t) + "\n" if val.eql? 'list'
    asset(data, key)
  end

  def multi_line(data, key)
    key + ': >' + break_address_2_lines(data.send(convert_to_column_names(key)).t) + "\n"
  end

  def block_title(data, key)
    key + ' ' + data.title.t + "\n\n\"" + data.send(convert_to_column_names(key)).t + "\"\n"
  end

  def block(data, key)
    return key + "\n\n\"" + data.send(convert_to_column_names(key)).t + "\"\n" if key.eql? 'What We Do'
    block_title(data, key)
  end

  def parse_yaml(data, key, val)
    return key + ': "' + data.send(convert_to_column_names(key)).t + "\"\n" if val.eql? 'single'
    return list(data, key, val) if val.eql?('list') || val.eql?('assets')
    return multi_line(data, key) if val.eql? 'multi-line'
    return block(data, key) if val.eql?('block')
  end

  def parse_md(data, key, val)
    return val if key.include?('new_line') || key.include?('file_')
    parse_yaml(data, key, val)
  end

  def create_yaml(worksheet_name, data)
    content = ''
    yaml_load(worksheet_name).each_pair { |key, val| content += parse_md(data, key, val) }
    content
  end

  def create_md(worksheet_num, worksheet_name, dir_name)
    create_file_structure(dir_name)
    sheet(worksheet_num).each  { |data| File.write('data/_' + dir_name + '/' + slugify(data.title.t) + '.markdown', create_yaml(worksheet_name, data)) }
  end

  def create_file_structure(name)
    FileUtils.mkdir "data/_#{name}" unless File.directory? "data/_#{name}"
    FileUtils.cp "bin/config/_example_#{name}.markdown", "data/_#{name}/_example.markdown"
  end

  def departments
    create_md(1, 'department', 'departments') # Worksheet 1 contains departments
  end

  def locations
    create_md(2, 'location', 'locations') # Worksheet 2 contains locations
  end

  def people
    create_md(3, 'people', 'people') # Worksheet 3 contains people
  end

  def services
    create_md(4, 'service', 'services') # Worksheet 4 contains services
  end

  def spaces
    create_md(5, 'space', 'spaces') # Worksheet 5 contains spaces
  end
end
