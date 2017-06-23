module LocationsHelper
  def last_result
    all_results.last
  end

  def find_checkbox(section_text, filter_text)
    find("input[type='checkbox'][name='#{section_name(section_text)}'][value='#{filter_value(filter_text)}']")
  end

  def section_name(section_text)
    {
      "Organization" => "org_type[]",
      "Type" => "type[]"
    }[section_text] || raise("Unrecognized section text: '#{section_text}'")
  end

  def filter_value(filter_text)
    {
      "Libraries" => "Library",
    }[filter_text] || filter_text
  end

  def page_link(page_number)
    find('.pagination__link', text: page_number)
  end
end
