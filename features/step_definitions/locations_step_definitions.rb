When /I uncheck "(.+)" in the "(.+)" filter$/ do |filter_name, section_name|
  within filter_group(section_name) do
    filter_checkbox(filter_name).set(false)
  end
  wait_for_loading_ux
end

When /^I check "(.+)" in the "(.+)" filter$/ do |filter_name, section_name|
  within filter_group(section_name) do
    filter_checkbox(filter_name).set(true)
  end
  wait_for_loading_ux
end

When /^I click on page "(.+)"$/ do |page_number|
  page_link(page_number).click
  wait_for_loading_ux
end

Then /^I should see "(.+)" as the last result$/ do |result_text|
  expect(last_result).to have_text result_text
end

Then /^the "(.+)" filter should have "(.+)" checked$/ do |section_name, filter_name|
  within filter_group(section_name) do
    expect(filter_checkbox(filter_name)).to be_checked
  end
end

Then /^I should see "(.+)" in the results$/ do |result_text|
  within(results) do
    expect(page).to have_text /#{result_text}/i
  end
end

Then /^I should not see "(.+)" in the results$/ do |result_text|
  within(results) do
    expect(page).to_not have_text /#{result_text}/i
  end
end
