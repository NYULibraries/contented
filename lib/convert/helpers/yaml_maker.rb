# Creates every single Yaml Field
class YamlMaker
  def self.slugify(slug_name)
    # Strip according to the mode, Remove leading/trailing hyphen and downcase
    slug_name.gsub(/[^[:alnum:]]+/, '-').gsub(/^\-|\-$/i, '').downcase
  end

  def self.yaml_load(structure)
    Hashie::Mash.new(YAML.load_file('config/conversions/' + structure + '.yml'))
  end

  def self.blocks_of_data(data, key, val)
    return MDFields.multi_line(data, key) if val.eql? 'multi-line'
    return MDFields.block(data, key) if val.eql? 'block'
  end

  def self.singles_empty_or_not(data, key)
    return key + ': ' + "\n" if data.send(MDFields.convert_to_column_names(key)).t.empty?
    key + ': "' + data.send(MDFields.convert_to_column_names(key)).t.strip + "\"\n"
  end

  def self.singles(data, key, val)
    return singles_empty_or_not(data, key) if val.eql? 'single'
    data.send(MDFields.convert_to_column_names(key)).t.include?('true') ? key + ': true' + "\n" : key + ': false' + "\n"
  end

  def self.parse_yaml(data, key, val)
    return singles(data, key, val) if val.eql?('single') || val.eql?('boolean')
    return MDFields.list(data, key, val) if val.eql?('list') || val.eql?('assets') || val.eql?('instance')
    blocks_of_data(data, key, val)
  end

  def self.parse_md(data, key, val)
    return val if key.include?('new_line') || key.include?('file_') || key.include?('hash')
    parse_yaml(data, key, val)
  end

  def self.create_yaml(worksheet_name, data)
    content = ''
    yaml_load(worksheet_name).each_pair { |key, val| content += parse_md(data, key, val) }
    content
  end

  def self.create_md(worksheet_num, worksheet_name, dir_name)
    create_file_structure(dir_name)
    GoogleSheet.sheet(worksheet_num).each  { |data| File.write('data/_' + dir_name + '/' + slugify(data.title.t) + '.markdown', create_yaml(worksheet_name, data)) }
  end

  def self.create_file_structure(name)
    FileUtils.mkdir "data/_#{name}" unless File.directory? "data/_#{name}"
    FileUtils.cp "config/conversions/_example_#{name}.markdown", "data/_#{name}/_example.markdown"
  end
end
