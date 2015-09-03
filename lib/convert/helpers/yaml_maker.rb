
module Conversion
  module Helpers
    # Creates every single Yaml Field
    class YamlMaker
      def self.slugify(slug_name)
        # Strip according to the mode, Remove leading/trailing hyphen and downcase
        slug_name.gsub(/[^[:alnum:]]+/, '-').gsub(/^\-|\-$/i, '').downcase
      end

      def self.yaml_load(structure)
        fail ArgumentError, 'parameter needs to be .yml file that exists in config/conversions/' unless File.exist? 'config/conversions/' + structure + '.yml'
        Hashie::Mash.new(YAML.load_file('config/conversions/' + structure + '.yml'))
      end

      def self.blocks_of_data(data, key, val)
        return MDFields.multi_line(data, key) if val.eql? 'multi-line'
        MDFields.block(data, key)
      end

      def self.singles_empty_or_not(data, key)
        return key + ': ' + "\n" if data.send(MDFields.convert_to_column_names(key)).tx.empty?
        key + ': "' + data.send(MDFields.convert_to_column_names(key)).tx.strip + "\"\n"
      end

      def self.singles(data, key, val)
        return singles_empty_or_not(data, key) if val.eql? 'single'
        data.send(MDFields.convert_to_column_names(key)).tx.include?('true') ? key + ': true' + "\n" : key + ': false' + "\n"
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

      def self.create_md(worksheet_num, worksheet_name)
        create_file_structure(worksheet_name)
        GoogleSheet.sheet(worksheet_num).each { |data| File.write('site/_' + worksheet_name + '/' + slugify(data.title.tx) + '.markdown', create_yaml(worksheet_name, data)) }
      end

      def self.create_file_structure(name)
        FileUtils.mkdir "site/_#{name}" unless File.directory? "site/_#{name}"
        FileUtils.cp "config/conversions/_example_#{name}.markdown", "site/_#{name}/_example.markdown"
      end
    end
  end
end
