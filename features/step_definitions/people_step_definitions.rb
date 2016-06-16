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
  expect(page).to_not have_selector('th', text: column_name)
end
