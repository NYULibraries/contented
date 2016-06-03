module PeopleHelper
  def all_columns(result_row)
    within(result_row) do
      all(column_selector)
    end
  end

  def column_selector
    'td'
  end
end
