Given(/^I want answers$/) do
end

When(/^I want the truth$/) do
  @truth = true
end

Then(/^I can handle the truth$/) do
  expect(@truth).to be_truthy
end
