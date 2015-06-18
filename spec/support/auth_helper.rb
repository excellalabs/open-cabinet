module AuthHelper
  def http_login
    user = Rails.application.secrets[:BASIC_AUTH_USERNAME]
    password =  Rails.application.secrets[:BASIC_AUTH_PASSWORD]
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end
end
