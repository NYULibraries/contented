Then(/^I should see \d+ formatted RSS feed results under "(.+)"$/) do |title_text|
  within(section_titled(title_text)) do
    expect(page).to have_selector rss_element_selector
    all_rss_elements.each do |rss_element|
      within(rss_element) do
        expect(page).to have_link nil, href: /^https?:\/\/[^\/]+\.nyu\.edu\//
        expect(page).to have_text date_with_author_regex
      end
    end
  end
end
