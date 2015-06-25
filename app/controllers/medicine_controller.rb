class MedicineController < ApplicationController
  before_action :find_or_create_cabinet, except: [:autocomplete]

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
    render 'medicine/shared/_shelves', layout: false
  end

  def add_to_cabinet
    outcome = @cabinet.add_to_cabinet(SearchableMedicine.find_by(name: medicine_params))
    render json: fetch_info(medicine_params), status: outcome ? :ok : :not_found
  end

  def destroy
    render json: fetch_info(determine_primary), status: @cabinet.destroy_medicine(medicine_params) ? :ok : :not_found
  end

  def query_for_information
    render json: fetch_info(determine_primary), status: :ok
  end

  private

  def determine_primary
    params[:primary_name] ? @cabinet.medicines.first.name : params[:primary_name]
  end

  def fetch_info(medicine)
    MedicineInformationService.fetch_information(medicine, @cabinet)
  end

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
