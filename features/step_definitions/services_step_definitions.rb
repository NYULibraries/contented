Then /^the topic "(.+)" should have a "(.+)" link$/ do |topic_name, link_name|
  expect(topic_section(topic_name)).to be_visible
  within(topic_section(topic_name)) do
    expect(page).to have_link link_name
  end
end

Then /^the topic "(.+)" should not have a "(.+)" link$/ do |topic_name, link_name|
  expect(topic_section(topic_name)).to be_visible
  within(topic_section(topic_name)) do
    expect(page).to_not have_link link_name
  end
end
