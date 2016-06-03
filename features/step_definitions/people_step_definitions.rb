When /^I select "(.+)" in the "(.+)" dropdown filter$/ do |option_text, filter_name|
  expect(filter_select(filter_name)).to be_visible
  select option_text, from: filter_select(filter_name)[:name]
  wait_for_loading_ux
end

When /^I click "(.+)"$/ do |link_text|
  click_on link_text
end

Then /^I should see a descending sort arrow next to the column "(.+)"$/ do |column_name|
  expect(column_title(column_name)).to be_visible
  expect(column_title(column_name)[:"data-sort"]).to eq "asc"
end

Then /^all results on the first page should begin with "(.+)"$/ do |text|
  expect(results).to be_visible
  all_results.each do |result_row|
    expect(result_row).to have_content /^#{text}/i
  end
end

Then /^all results should have "(.+)" in the "(.+)" column$/ do |result_text, column_name|
  column_index = get_column_index(column_name)
  expect(results).to be_visible
  all_results.each do |result_row|
    within(result_row) do
      expect(nth_column(column_index)).to have_text result_text
    end
  end
end

Then /^results should have a column "(.+)"$/ do |column_name|
  expect(column_title(column_name)).to be_visible
end

Then /^results should not have a column "(.+)"$/ do |column_name|
  expect{ column_title(column_name) }.to raise_error Capybara::ElementNotFound
end

Then /^all results should link from each column$/ do
  expect(results).to be_visible
  all_results.each do |result_row|
    all_columns(result_row).each do |row_column|
      expect(row_column).to have_css 'a'
    end
  end
end
