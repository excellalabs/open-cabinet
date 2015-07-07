class LoginPage
  include Capybara::DSL, Rails.application.routes.url_helpers

  def visit_login_page
    visit(new_user_session_path)
  end

  def sign_in(user)
    fill_in('user_email', with: user.email)
    fill_in('user_password', with: user.password)
    sauce_click_wrapper(find('#sign_in'))
  end

  def sign_out
    sauce_click_wrapper(page.find('#sign-out-link'))
  end

  def continue_as_guest
    sauce_click_wrapper(page.find('#continue-as-guest-button'))
  end
end
