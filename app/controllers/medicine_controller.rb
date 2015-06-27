class MedicineController < ApplicationController
  before_action :find_cabinet_interactions, except: [:autocomplete, :update_primary_medicine]
  before_action :find_or_create_cabinet, only: [:update_primary_medicine]

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

  def update_primary_medicine
    write_primary_medicine(params[:medicine])
    find_primary_medicine
    find_interactions
    render 'medicine/shared/_shelves', layout: false
  end

  def add_to_cabinet
    @cabinet.add_to_cabinet(SearchableMedicine.find_by(name: params[:medicine]))
    @cabinet.reload
    write_primary_medicine(params[:medicine])
    find_primary_medicine
    find_interactions
    render 'medicine/shared/_shelves', layout: false
  end

  def destroy
    @cabinet.destroy_medicine(params[:medicine])
    find_primary_medicine
    find_interactions
    render 'medicine/shared/_shelves', layout: false
  end

  def information
    render json: fetch_info(primary_medicine_name), status: :ok
  end

  private

  def fetch_info(medicine)
    return {} unless medicine
    MedicineInformationService.fetch_information(medicine, @cabinet)
  end

  def write_primary_medicine(medicine_name)
    medicine = @cabinet.find_medicine_by_name(medicine_name)
    session[:primary_medicine_id] = medicine.id unless medicine.nil?
  end

  def find_primary_medicine
    medicine = @cabinet.primary_medicine(session[:primary_medicine_id])
    write_primary_medicine(medicine.name) unless medicine.nil?
    @primary_medicine = medicine
  end

  def primary_medicine_name
    @primary_medicine.try(:name)
  end

  def find_cabinet_interactions
    find_or_create_cabinet
    find_primary_medicine
    find_interactions
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

  def find_interactions
    @interactions = MedicineInformationService.find_cabinet_interactions(@cabinet)
  end
end
