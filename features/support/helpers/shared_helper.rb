module SharedHelper
  def results
    find('.table--collection')
  end

  def result_count
    all_results.count
  end

  def first_result
    within(results) do
      first(result_row_selector)
    end
  end

  def all_results
    within(results) do
      all(result_row_selector)
    end
  end

  def column_title(column_name)
    find('th', text: /^#{column_name}$/i)
  end

  def cell_selector_for_column(column_name)
    {
      "Located in" => ".table__cell--location",
      "Library" => ".table__cell--location",
      "Library Department" => ".table__cell--departments",
    }[column_name]
  end

  def result_row_selector
    "tbody tr"
  end

  def dropdown_filter(filter_text)
    find("select[name='#{filter_name(filter_text)}']")
  end

  def filter_name(filter_text)
    {
      "Library Department" => "departments",
      "Subject Specialty" => "subject_specialties",
      "Located in" => "location",
    }[filter_text] || raise("Unrecognzied filter: \"#{filter_text}\"")
  end

  def get_column_index(column_name)
    all('th').index{|col_header| col_header.has_text?(column_name) }
  end

  def nth_column(column_index)
    all(column_selector)[column_index]
  end

  def wait_for_loading_ux(**options)
    expect(page).to have_css('.is-loading', **options)
    expect(page).to_not have_css('.is-loading', **options)
  rescue RSpec::Expectations::ExpectationNotMetError => e
    puts "WARNING: Loading UX not found; sleeping instead"
    sleep options[:wait] || 2
  end
end
