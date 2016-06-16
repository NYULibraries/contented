module LocationsHelper
  def last_result
    all_results.last
  end

  def filter_group(section_name)
    first('.filter__group', text: /#{section_name}/i)
  end

  def filter_checkbox(filter_name)
    within first('label', text: /#{filter_name}/i) do
      first('input')
    end
  end

  def page_link(page_number)
    find('.pagination__link', text: page_number)
  end
end
