module PeopleHelper
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

  def all_columns(result_row)
    within(result_row) do
      all(column_selector)
    end
  end

  def column_selector
    'td'
  end
end
