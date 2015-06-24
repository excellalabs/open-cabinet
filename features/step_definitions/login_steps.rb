Given(/^a user visits the login page$/) do
  @login_page.visit_login_page
end

When(/^the user logs in with valid credentials$/) do
  @login_page.sign_in(@user)
end

Then(/^the user will see their cabinet$/) do
  expect(page.has_selector?('div.cabinet')).to be_truthy
end

Given(/^a user is signed in$/) do
  @login_page.visit_login_page
  @login_page.sign_in(@user)
end

When(/^the user logs out$/) do
  @login_page.sign_out
end

Then(/^the user will no longer be authenticated$/) do
  expect(page.has_selector?('form.new_user')).to be_truthy
end
