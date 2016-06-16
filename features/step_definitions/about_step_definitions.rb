Then /^I should see a topic "(.+)"$/ do |topic_name|
  expect(topic_section(topic_name)).to be_visible
end

Then /^I should see "(.+)" as the first topic result$/ do |result_text|
  expect(topic_results).to be_visible
  expect(first_topic_result).to have_text result_text
end
