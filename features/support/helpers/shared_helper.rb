module SharedHelper
  def results
    find('.table--collection')
  end

  def all_results
    within results do
      all(result_row_selector)
    end
  end

  def column_title(column_name)
    find('th', text: /^#{column_name}$/i)
  end

  def result_row_selector
    "tbody tr"
  end

  def filter_select(filter_name)
    all('select').detect do |select_input|
      within(select_input) do
        all("option[value='']", text: filter_name).count == 1
      end
    end
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
