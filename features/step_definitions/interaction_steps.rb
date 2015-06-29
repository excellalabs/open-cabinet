Given(/^I have "(.*?)", "(.*?)", and "(.*?)" in my cabinet$/) do |arg1, arg2, arg3|
  cabinet_medicines = [Medicine.find_by_name(arg1), Medicine.find_by_name(arg2), Medicine.find_by_name(arg3)]

  @cabinet_page.create_session_cabinet_with_medicines(cabinet_medicines)
end

When(/^I select "(.*?)" as my primary$/) do |arg1|
  @primary_med = arg1
  @cabinet_page.select_medicine(arg1)
end

Then(/^I should see "(.*?)" as my primary$/) do |arg1|
  within(@cabinet_page.active_pill_container) do
    assert_selector(@cabinet_page.pill_name_text, text: arg1)
  end
end

Then(/^that it interacts with "(.*?)"$/) do |arg1|
  within(@cabinet_page.interact_pill_container) do
    assert_selector(@cabinet_page.pill_name_text, text: arg1)
  end
end

Then(/^that it does not interact with "(.*?)"$/) do |arg1|
  within(@cabinet_page.disabled_pill_container) do
    assert_selector(@cabinet_page.pill_name_text, text: arg1)
  end
end

Then(/^I should see label data$/) do
  wait_for_ajax
  within('#medicine_information') do
    expect(find('.primary-name').text).to eq(@primary_med)
  end
  expect(find('#indications-and-usage').text.length).to be > 0
  expect(find('#dosage-and-administration').text.length).to be > 0
  expect(find('#warnings').text.length).to be > 0
end

And(/^I click the interactions blurb$/) do
  page.find('#interactions-count-container').trigger('click')
end

And(/^I select the first interaction tile$/) do
  assert_selector('#no-data-loaded-container')
  assert_no_selector('#interaction-data-container')
  @cabinet_page.interaction_tiles.first.trigger('click')
end

Then(/^the first tile becomes active$/) do
  assert_no_selector('#no-data-loaded-container')
  assert_selector('#interaction-data-container')
  expect(@cabinet_page.interaction_tiles.first[:class].include?('active')).to be_truthy
end

And(/^the interacting drug "(.*?)" is highlighted in the interactions text$/) do |arg1|
  assert_selector(".#{arg1}.highlight.neon")
end
