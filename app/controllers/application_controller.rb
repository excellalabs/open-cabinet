class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include BasicAuth
  ensure_security_headers

  def after_sign_in_path_for(_user)
    session.delete(:cabinet_id)
    cabinet_path
  end

  def sign_out_and_redirect(_user)
    reset_sesion
    root_path
  end

  def current_user
    @current_user ||= super && User.includes(cabinet: [:medicines]).find(@current_user.id)
  end
end
