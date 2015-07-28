require 'open-uri'
require 'hashie'
require 'json'
require 'figs'
Figs.load

# Grabs data from spreadsheet and converts it into a Markdown files
class Convert
  def initialize
    FileUtils.rm_rf 'data'
    FileUtils.mkdir_p 'data'
    FileUtils.cp 'bin/config/README.md', 'data'
    FileUtils.mkdir_p 'data/_departments'
    FileUtils.mkdir_p 'data/_locations'
    FileUtils.mkdir_p 'data/_people'
    FileUtils.mkdir_p 'data/_services'
    FileUtils.mkdir_p 'data/_spaces'
  end

  def uri(sheet_num)
    "http://spreadsheets.google.com/feeds/list/#{ENV['GOOGLE_SHEET_KEY']}/#{sheet_num}/public/values?alt=json"
  end

  def sheet(sheet_num)
    # Making objects of json file generated from spreadsheet
    # Remove gsx$ and $t from column and cell names so varable names dont have $
    Hashie::Mash.new(JSON.parse(open(uri(sheet_num)).read.gsub('"gsx$', '"').gsub('"$t"', '"t"'))).feed.entry
  end

  def listify(element)
    return '' if element.empty?
    # Replace ; with new line and - for list in Yaml
    "\n  - \"" + element.gsub(';', "\"\n  - \"") + "\""
  end

  def listify_assets(asset)
    return '' if asset.empty?
    "\n  -  " + asset.gsub(';', "\"\n  - ").gsub('path:', "path: \"").gsub('name:', "\"\n     name: \"") + "\""
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

  def block_title
    key + ' ' + data.title.t + "\n\n\"" + data.send(convert_to_column_names(key)).t + "\"\n"
  end

  def block(data, key)
    return key + "\n\n\"" + data.send(convert_to_column_names(key)).t + "\"\n" if key.eql? 'What We Do'
    block_title
  end

  def parse_yaml(data, key, val)
    return key + ': "' + data.send(convert_to_column_names(key)).t + "\"\n" if val.eql? 'single'
    return list(data, key, val) if val.eql?('list') || val.eql?('assets')
    return multi_line(data, key) if val.eql? 'multi-line'
    return block(data, key) if val.eql?('block')
  end

  def parse_md(data, key, val)
    content = ''
    if key.include?('new_line') || key.include?('file_')
      content += val
    else
      content += parse_yaml(data, key, val)
    end
    content
  end

  def create_md(worksheet_num, worksheet_name, dir_name)
    sheet(worksheet_num).each  do |data|
      content = ''
      yaml_load(worksheet_name).each_pair do |key, val|
        content += parse_md(data, key, val)
      end
      File.write('data/_' + dir_name + '/' + slugify(data.title.t) + '.markdown', content)
    end
  end

  def departments
    # Worksheet 1 contains departments
    create_md(1, 'department', 'departments')
  end

  def locations
    # Worksheet 2 contains locations
    create_md(2, 'location', 'locations')
  end

  def people
    # Worksheet 3 contains people
    create_md(3, 'people', 'people')
  end

  def services
    # Worksheet 4 contains services
    create_md(4, 'service', 'services')
  end

  def spaces
    # Worksheet 5 contains spaces
    create_md(5, 'space', 'spaces')
  end
end
