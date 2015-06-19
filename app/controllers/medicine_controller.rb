class MedicineController < ApplicationController
  def index
  end

  def search
    search = OpenFda::Client.new
    query = search.query_by_med_name(params[:search_input])
    results = JSON.parse(query.body)['results']
    @display_results = results.map { |med| med['openfda']['brand_name'] }.flatten
  end
end
