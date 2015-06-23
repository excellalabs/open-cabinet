class MedicineController < ApplicationController
  before_action :find_or_create_cabinet, except: :search
  def index
    render 'search'
  end

  def search
    response = OpenFda::Client.new.query_by_med_name(params[:search_input], 100).body
    results = JSON.parse(response)['results'].to_a
    @display_results = build_results(results)

    respond_to do |format|
      format.json { render json: @display_results.to_json }
      format.html { @display_results }
    end
  end

  def autocomplete
    render json: SearchableMedicine.all.map(&:name)
  end

  def cabinet
  end

  def add_to_cabinet
    render json: {}, status: @cabinet.add_to_cabinet(medicine_params) ? :ok : :not_found
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

  def build_results(results)
    checked_results = !results.any? ? [] : results
    checked_results.map do |med|
      next if med['openfda']['brand_name'].nil?
      { brand_name: med['openfda']['brand_name'].first.titleize,
        set_id: med['set_id'],
        active_ingredient: med['active_ingredient'].nil? ? '' : med['active_ingredient'].first }
    end.flatten.compact
  end
end
