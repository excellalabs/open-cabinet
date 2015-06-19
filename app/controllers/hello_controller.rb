class HelloController < ApplicationController
  before_action :authenticate_user!, only: :secure
  def index
  end

  def secure
  end
end
