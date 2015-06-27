class MedicineController < ApplicationController
  before_action :get_cabinet_interactions, except: [:autocomplete]

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
    outcome = @cabinet.add_to_cabinet(SearchableMedicine.find_by(name: params[:medicine]))
    render json: fetch_info(params[:medicine]), status: outcome ? :ok : :not_found
  end

  def destroy
    status = @cabinet.destroy_medicine(params[:medicine])
    render json: fetch_info(determine_primary_from_delete), status: status ? :ok : :not_found
  end

  def query_for_information
    render json: fetch_info(determine_primary), status: :ok
  end

  private

  def determine_primary_from_delete
    params[:primary_name] == params[:medicine] ? @cabinet.medicines.first.try(:name) : params[:primary_name]
  end

  def determine_primary
    return nil if @cabinet.medicines.blank?
    params[:primary_name].blank? ? @cabinet.medicines.first.name : params[:primary_name]
  end

  def fetch_info(medicine)
    return {} unless medicine
    MedicineInformationService.fetch_information(medicine, @cabinet)
  end

  def get_cabinet_interactions
    find_or_create_cabinet
    get_interactions
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

  def get_interactions
    @interactions = MedicineInformationService.find_cabinet_interactions(@cabinet)
    puts @interactions.inspect
  end
end
