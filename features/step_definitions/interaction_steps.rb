Given(/^I have "(.*?)", "(.*?)", and "(.*?)" in my cabinet$/) do |arg1, arg2, arg3|
  cabinet_medicines = [Medicine.find_by_name(arg1), Medicine.find_by_name(arg2), Medicine.find_by_name(arg3)]

  @cabinet_page.create_session_cabinet_with_medicines(cabinet_medicines)
end

When(/^I select "(.*?)" as my primary$/) do |arg1|
  @primary_med = arg1
  @cabinet_page.select_medicine(arg1)
end

Then(/^I should see "(.*?)" as my primary$/) do |arg1|
  find('div.pill-container.active') do
    find('div.pill-name-text', text: arg1, match: :prefer_exact)
  end
end

Then(/^that it interacts with "(.*?)"$/) do |arg1|
  find('div.pill-container.interact') do
    find('div.pill-name-text', text: arg1, match: :prefer_exact)
  end
end

Then(/^that it does not interact with "(.*?)"$/) do |arg1|
  find('div.pill-container.disabled') do
    find('div.pill-name-text', text: arg1, match: :prefer_exact)
  end
end

Then(/^I should see label data$/) do
  wait_for_ajax
  find('#medicine_information') do
    expect(find('.primary-name').text).to eq(@primary_med)
  end
  expect(find('#indications-and-usage').text.length).to be > 0
  expect(find('#dosage-and-administration').text.length).to be > 0
  expect(find('#warnings').text.length).to be > 0
end