require_relative 'field_format'
# Formats the Markdown field types
class MDFields
  def self.convert_to_column_names(name)
    name.downcase.delete('_').delete(' ')
  end

  def self.asset(data, key)
    FieldFormat.listify_assets(data.send(convert_to_column_names(key)).t) + "\n"
  end

  def self.list_or_instance(data, key, val)
    return FieldFormat.listify(data.send(convert_to_column_names(key)).t) if val.eql? 'list'
    FieldFormat.instancify(data.send(convert_to_column_names(key)).t)
  end

  def self.list(data, key, val)
    return key + ':' + list_or_instance(data, key, val) + "\n" if val.eql?('list') || val.eql?('instance')
    key + ':' + asset(data, key)
  end

  def self.multi_line(data, key)
    key + ': |' + FieldFormat.break_address_2_lines(data.send(convert_to_column_names(key)).t) + "\n"
  end

  def self.block_title(data, key, put_title)
    title = put_title ? data.title.t : ''
    key + ' ' + title + "\n\n" + data.send(convert_to_column_names(key)).t.strip + "\n"
  end

  def self.block(data, key)
    return key + "\n\n" + data.send(convert_to_column_names(key)).t + "\n" if key.eql? 'What We Do'
    return block_title(data, key, true) if key.casecmp('About') == 0
    block_title(data, key, false)
  end
end
