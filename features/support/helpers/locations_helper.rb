module LocationsHelper
  def results
    find('.table--collection')
  end

  def first_result
    within results do
      first(result_row_selector)
    end
  end

  def last_result
    within results do
      all(result_row_selector).last
    end
  end

  def filter_group(section_name)
    first('.filter__group', text: /#{section_name}/i)
  end

  def filter_checkbox(filter_name)
    within first('label', text: /#{filter_name}/i) do
      first('input')
    end
  end

  def column_title(column_name)
    find('th', text: /#{column_name}/i)
  end

  def page_link(page_number)
    find('.pagination__link', text: page_number)
  end

  def wait_for_loading_ux(**options)
    expect(page).to have_css('.is-loading', **options)
    expect(page).to_not have_css('.is-loading', **options)
  end

  def result_row_selector
    ".item"
  end
end
