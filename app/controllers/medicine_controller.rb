class MedicineController < ApplicationController
  before_action :find_or_create_cabinet, except: [:autocomplete]
  before_action :init_cabinet, only: [:medicine_information]
  after_action :write_primary_medicine, only: [:update_primary_medicine, :add_to_cabinet, :destroy]

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
    @cabinet.identify_primary(params[:medicine])
    render 'medicine/shared/_shelves', layout: false
  end

  def add_to_cabinet
    result = @cabinet.add_to_cabinet(SearchableMedicine.where('lower(name) = ?', params[:medicine].downcase).first)
    @error_message = "Could not find results for \'#{params[:medicine]}\', please try again." unless result
    @cabinet.reload
    render 'medicine/shared/_shelves', layout: false
  end

  def destroy
    @cabinet.destroy_medicine(params[:medicine], session[:primary_medicine_id])
    render 'medicine/shared/_shelves', layout: false
  end

  def medicine_information
    @primary_medicine = @cabinet.determine_primary_medicine(session[:primary_medicine_id])
    render 'medicine/shared/_medicine_information', layout: false
  end

  private

  def write_primary_medicine
    session[:primary_medicine_id] = @cabinet.primary_medicine.set_id
  end

  def recalculate_cabinet_interactions
    @cabinet.rebuild_cabinet
    @primary_medicine = @cabinet.determine_primary_medicine(session[:primary_medicine_id])
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
    recalculate_cabinet_interactions
  end
end
