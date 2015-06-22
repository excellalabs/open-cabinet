Given(/^I am on the home page$/) do
  @home_page.visit_home_page
end

When(/^I start typing a medication name$/) do
  @home_page.type_search_characters(@medication)
end

Then(/^I should see the medication in the list$/) do
  expect(@medication).to eq(@home_page.autocomplete_text)
end