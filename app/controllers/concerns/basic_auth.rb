module BasicAuth
  extend ActiveSupport::Concern

  included do
    before_action :http_authenticate, :set_cookie
  end

  def http_authenticate
    return if cookie_exists?
    response = authenticate
    response
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.secrets[:BASIC_AUTH_USERNAME] && password == Rails.application.secrets[:BASIC_AUTH_PASSWORD]
    end
  end

  def cookie_exists?
    cookies.key?(:fda_app) && cookies[:fda_app] == 'authenticated'
  end

  def set_cookie
    return unless request.authorization.nil?
    cookies[:fda_app] = {
      value: 'authenticated',
      expires: 1.day.from_now,
      domain: :all
    }
  end
end
