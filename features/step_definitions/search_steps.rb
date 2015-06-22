Given(/^the user is viewing the search page$/) do
  visit lookup_path
end

When(/^the user searches for "(.*?)"$/) do |term|
  fill_in 'search_input', with: term
  click_button 'Search'
end

Then(/^the user will see a list of medicines$/) do
  expect(page.has_selector?('div.medicine-item')).to equal true
end

Then(/^the user will be prompted to search again$/) do
  expect(page.has_selector?('div.medicine-item')).to be_falsy
end
