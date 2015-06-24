class SessionController < ApplicationController
  def session_clear
    session.delete(:cabinet_id)
  end
end
