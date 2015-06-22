class MedicineController < ApplicationController
  before_action :find_or_create_cabinet, except: :search
  def index
  end

  def search
    search = OpenFda::Client.new
    query = search.query_by_med_name(params[:search_input])
    results = JSON.parse(query.body)['results']
    @display_results = results.map { |med| med['openfda']['brand_name'] }.flatten
  end

  def autocomplete
    render json: SearchableMedicine.all.map(&:name)
  end

  def cabinet
  end

  def add_to_cabinet
    @cabinet.add_to_cabinet(medicine_params)
  end

  private

  def medicine_params
    params.require(:medicine).permit(:name, :set_id)
  end

  def find_or_create_cabinet
    if session[:cabinet_id].nil?
      @cabinet = Cabinet.create!
      session[:cabinet_id] = @cabinet.id
    else
      @cabinet = Cabinet.find_by_id(session[:cabinet_id])
    end
  end
end
