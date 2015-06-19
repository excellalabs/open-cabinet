class DrugSearchController < ApplicationController
  before_action :authenticate_user!, only: :secure
  def index
  end

  def search
    result = %w(Tylenol Advil)
    render json: result
  end

  def secure
  end
end
