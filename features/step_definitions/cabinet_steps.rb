Given(/^I am on the cabinet page$/) do
  @cabinet_page.visit_home_page
end

When(/^I start typing a medication name$/) do
  @cabinet_page.type_search_characters(@medication)
end

Then(/^I should see the medication in the list$/) do
  expect(@medication).to eq(@cabinet_page.autocomplete_text)
end

When(/^I select that medication$/) do
  @cabinet_page.select_autocomplete_text(@autocomplete_text)
  @cabinet_page.press_add_button
end

Then(/^I should see the medication in my cabinet$/) do
  expect(find('.pill-name', text: @medication).visible?).to be true
end
