class MedicineController < ApplicationController
  before_action :find_or_create_cabinet, except: :search
  caches_action :autocomplete

  def autocomplete
    ary = []
    SearchableMedicine.find_in_batches(batch_size: 5000) do |group|
      ary.push(*group)
    end
    render json: ary.map(&:name)
  end

  def cabinet
  end

  def add_to_cabinet
    med = SearchableMedicine.find_by(name: medicine_params['name'])
    @cabinet.add_to_cabinet(name: med.name, set_id: med.set_id)
    render 'shelves', layout: false
  end

  def destroy
    @cabinet.medicines.find { |medicine| medicine.id.to_s == params['id'] }.destroy
    @cabinet.reload
    render 'shelves', layout: false
  end

  def query_for_all_interactions
    render json: InteractionService.fetch_all_interactions(params[:medicine_id], @cabinet)
  end

  private

  def medicine_params
    params.require(:medicine).permit(:name, :set_id, :active_ingredient)
  end

  def find_or_create_cabinet
    if session[:cabinet_id].nil?
      @cabinet = Cabinet.create!
      session[:cabinet_id] = @cabinet.id
    else
      @cabinet = Cabinet.includes(:medicines).find_by_id(session[:cabinet_id])
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
