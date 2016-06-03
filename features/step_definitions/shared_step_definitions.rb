Given(/^I visit the homepage$/) do
  visit root_path
end

Given /^I click on the "(.+)" link$/ do |link_text|
  click_link_or_button link_text
  expect(page).to have_text link_text
end

When /^I search for the term "(.+)"$/ do |search_text|
  within "main" do
    fill_in "section__search__field", with: search_text
    click_on "🔍"
  end
end

Then /^I should see only "(.+)" in the results$/ do |result_text|
  within(results) do
    expect(page).to have_css result_row_selector, count: 1, text: /#{result_text}/i
  end
end
