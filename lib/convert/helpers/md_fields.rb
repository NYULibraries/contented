require_relative 'field_format'
# Formats the Markdown field types
class MDFields
  def self.convert_to_column_names(name)
    name.gsub('_', '').gsub(' ', '').downcase
  end

  def self.asset(data, key)
    key + ':' + FieldFormat.listify_assets(data.send(convert_to_column_names(key)).t) + "\n"
  end

  def self.list(data, key, val)
    return key + ':' + FieldFormat.listify(data.send(convert_to_column_names(key)).t) + "\n" if val.eql? 'list'
    asset(data, key)
  end

  def self.multi_line(data, key)
    key + ': >' + FieldFormat.break_address_2_lines(data.send(convert_to_column_names(key)).t) + "\n"
  end

  def self.block_title(data, key)
    key + ' ' + data.title.t + "\n\n\"" + data.send(convert_to_column_names(key)).t + "\"\n"
  end

  def self.block(data, key)
    return key + "\n\n\"" + data.send(convert_to_column_names(key)).t + "\"\n" if key.eql? 'What We Do'
    block_title(data, key)
  end
end
