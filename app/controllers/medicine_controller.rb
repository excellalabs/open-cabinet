class MedicineController < ApplicationController
  before_action :find_or_create_cabinet, only: [:update_primary_medicine, :add_to_cabinet, :destroy]
  before_action :init_cabinet, only: [:medicine_information, :cabinet]

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

  def about
  end

  def update_primary_medicine
    calculate_cabinet_interactions_and_set_primary(params[:medicine])
    render 'medicine/shared/_shelves', layout: false
  end

  def add_to_cabinet
    result = @cabinet.add_to_cabinet(SearchableMedicine.where('lower(name) = ?', params[:medicine].downcase).first)
    if result
      calculate_cabinet_interactions_and_set_primary(result.name)
    else
      @error_message = "Could not find results for \'#{params[:medicine]}\', please try again."
    end
    render 'medicine/shared/_shelves', layout: false
  end

  def destroy
    session[:primary_medicine_name] = nil if session[:primary_medicine_name] == params[:medicine]
    @cabinet.destroy_medicine(params[:medicine], session[:primary_medicine_name])
    calculate_cabinet_interactions_and_set_primary
    render 'medicine/shared/_shelves', layout: false
  end

  def medicine_information
    render 'medicine/shared/_medicine_information', layout: false
  end

  private

  def calculate_cabinet_interactions_and_set_primary(medicine_name = session[:primary_medicine_name])
    @primary_medicine = @cabinet.identify_primary(medicine_name)
    session[:primary_medicine_name] = @primary_medicine.name if @primary_medicine
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

  def init_cabinet
    find_or_create_cabinet
    calculate_cabinet_interactions_and_set_primary
  end
end
