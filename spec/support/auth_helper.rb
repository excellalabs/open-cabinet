module AuthHelper
  def http_login
    user = Rails.configuration.basic_auth_user
    password =  Rails.configuration.basic_auth_pass
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end
end
