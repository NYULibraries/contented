module MarkdownFieldHelpers
  def to_yaml_list(str)
    "\n#{str.split(';').collect { |item| "  - '#{item.strip}'" }.join("\n")}" unless str.to_s.empty?
  end

  def to_yaml_object(str)
    "\n#{str.split(';').collect { |item| "  #{item.strip}" }.join("\n")}" unless str.to_s.empty?
  end
end
