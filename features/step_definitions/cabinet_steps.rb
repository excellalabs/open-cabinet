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

When(/^I enter an incorrect search term$/) do
  @incorrect_term = 'not found'
  @cabinet_page.type_search_characters(@incorrect_term)
  @cabinet_page.press_add_button
end

Then(/^I receive an error message letting me know that I need to try a different search$/) do
  error_message = "Could not find results for '#{@incorrect_term}', please try again."
  expect(error_message).to eq(find('#error-message-container .error-message').text)
end
