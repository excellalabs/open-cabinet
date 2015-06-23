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
    gon.meds = @cabinet.medicines
    gon.images = (1..MedicineShelfHelper::NUM_IMAGES).map { |num| ActionController::Base.helpers.asset_path("pills-0#{num}.png") }
  end

  def refresh_shelves
    render 'shelves', layout: false if request.xhr?
  end

  def add_to_cabinet
    med = SearchableMedicine.find_by(name: medicine_params)
    @cabinet.add_to_cabinet(name: med.name, set_id: med.set_id)
    render json: { name: med.name, set_id: med.set_id }, status: :ok
  end

  def destroy
    render json: nil, status: :ok if @cabinet.medicines.find_by(name: medicine_params).destroy
  end

  def query_for_information
    render json: MedicineInformationService.fetch_information(params[:medicine_id], @cabinet)
  end

  private

  def medicine_params
    params.require(:medicine)
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
