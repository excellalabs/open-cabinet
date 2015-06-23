class Cabinet < ActiveRecord::Base
  belongs_to :user
  has_many :medicines

  def add_to_cabinet(params)
    med = Medicine.find_or_create_by(set_id: params[:set_id])
    return if medicines.any? { |medicine| medicine.set_id == med.set_id }
    med.name = params[:name]
    med.active_ingredient = params[:active_ingredient]
    medicines << med
    save!
  end
end
