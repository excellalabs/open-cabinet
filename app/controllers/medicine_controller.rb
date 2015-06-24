class MedicineController < ApplicationController
  before_action :find_or_create_cabinet, except: [:search, :autocomplete]

  def autocomplete
    ary = []
    Rails.cache.fetch('autocomplete', expires_in: 6.hour) do
      SearchableMedicine.find_in_batches(batch_size: 5000) do |group|
        ary.push(*group)
      end
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
    return @cabinet = Cabinet.includes(:medicines).find_by_id(session[:cabinet_id]) if session[:cabinet_id]
    user = current_user
    if user && user.cabinet
      @cabinet = user.cabinet
    else
      @cabinet = Cabinet.create!(user: user)
    end
    session[:cabinet_id] = @cabinet.id
  end
end
