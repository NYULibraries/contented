# Formats the Markdown fields
class FieldFormat
  def self.strip_spaces_in_between(string, char)
    string.gsub(/\s+#{char}/, "#{char}").gsub(/#{char}\s+/, "#{char}")
  end

  def self.listify(element)
    return '' if element.empty?
    element = strip_spaces_in_between(element, ';') # Replace ; with new line and - for list in Yaml
    "\n  - \"" + element.gsub(';', "\"\n  - \"") + "\""
  end

  def self.instancify(element)
    return '' if element.empty?
    element = strip_spaces_in_between(element, ';') # Replace ; with new line and - for list in Yaml
    "\n  " + element.gsub(';', "\n  ")
  end

  def self.listify_assets(asset)
    return '' if asset.empty?
    asset = strip_spaces_in_between(asset, ';')
    asset = strip_spaces_in_between(asset, '>')
    "\n  - path: \"" + asset.gsub(';', "\"\n  - path: \"").gsub('>', "\"\n    name: \"") + "\""
  end

  def self.break_address_2_lines(address)
    return '' if address.empty?
    "\n  " + address.sub(',', "\n  ")
  end
end
