module HomepageHelper
  def section_titled(title_text)
    find('section', text: title_text)
  end

  def rss_element_selector
    "li.item"
  end

  def all_rss_elements
    all(rss_element_selector)
  end

  def date_with_author_regex
    /\w+ \d+, \d{4} by \w+/
  end
end
