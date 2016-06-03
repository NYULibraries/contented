When /^I click "(.+)"$/ do |link_text|
  click_on link_text
end

Then /^all results on the first page should begin with "(.+)"$/ do |text|
  expect(results).to be_visible
  all_results.each do |result_row|
    expect(result_row).to have_content /^#{text}/i
  end
end

Then /^results should have a column "(.+)"$/ do |column_name|
  expect(column_title(column_name)).to be_visible
end

Then /^results should not have a column "(.+)"$/ do |column_name|
  expect{ column_title(column_name) }.to raise_error Capybara::ElementNotFound
end