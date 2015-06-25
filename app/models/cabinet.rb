class Cabinet < ActiveRecord::Base
  belongs_to :user
  has_many :cabinet_medicines
  has_many :medicines, through: :cabinet_medicines

  def add_to_cabinet(params)
    med = Medicine.find_or_create_by(set_id: params[:set_id])
    return if medicines.any? { |medicine| medicine.set_id == med.set_id }
    med.update(name: params[:name], active_ingredient: params[:active_ingredient])
    medicines << med
    save!
  end
end
