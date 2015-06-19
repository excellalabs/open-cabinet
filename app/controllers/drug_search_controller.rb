class DrugSearchController < ApplicationController
  def index
  end

  def search
    result = %w(Tylenol Advil)
    render json: result
  end
end
