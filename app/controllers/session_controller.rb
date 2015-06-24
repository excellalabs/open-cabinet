class SessionController < ApplicationController
  def session_clear
    session[:cabinet_id] = nil
  end
end
