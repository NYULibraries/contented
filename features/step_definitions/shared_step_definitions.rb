Given(/^I visit the homepage$/) do
  visit root_path
end

Given /^I click on the "(.+)" link$/ do |link_text|
  click_link_or_button link_text
  expect(page).to have_text link_text
end

When /^I click "(.+)"$/ do |link_text|
  click_on link_text
end

When /^I search for the term "(.+)"$/ do |search_text|
  within "main" do
    fill_in "section__search__field", with: search_text
    click_on "🔍"
  end
  wait_for_loading_ux
end

When /^I select "(.+)" in the "(.+)" dropdown filter$/ do |option_text, filter_name|
  sleep 5
  expect(filter_select(filter_name)).to be_visible
  select option_text, from: filter_select(filter_name)[:name]
  wait_for_loading_ux
end

When /^I click the column title "(.+)"$/ do |column_name|
  column_title(column_name).hover
  column_title(column_name).click
  wait_for_loading_ux
end

Then /^I should see only "(.+)" in the results$/ do |result_text|
  within(results) do
    expect(page).to have_css result_row_selector, count: 1, text: /#{result_text}/i
  end
end

Then /^I should see "(.+)" as the first result$/ do |result_text|
  expect(first_result).to have_text result_text
end

Then /^all results should have "(.+)" in the "(.+)" column$/ do |result_text, column_name|
  expect(results).to be_visible
  expect(results).to have_selector(cell_selector_for_column(column_name), text: result_text, count: result_count)
end

Then /^I should see a descending sort arrow next to the column "(.+)"$/ do |column_name|
  expect(column_title(column_name)).to be_visible
  expect(column_title(column_name)[:"data-sort"]).to eq "asc"
end

Then /^I should see an ascending sort arrow next to the column "(.+)"$/ do |column_name|
  expect(column_title(column_name)).to be_visible
  expect(column_title(column_name)[:"data-sort"]).to eq "desc"
end

Then /^all results should link from each column$/ do
  expect(results).to be_visible
  all_results.each do |result_row|
    all_columns(result_row).each do |row_column|
      expect(row_column).to have_css 'a'
    end
  end
end
