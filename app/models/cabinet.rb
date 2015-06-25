class Cabinet < ActiveRecord::Base
  belongs_to :user
  has_many :cabinet_medicines
  has_many :medicines, through: :cabinet_medicines

  def add_to_cabinet(searchable_medicine)
    med = Medicine.find_or_create_by(set_id: searchable_medicine.set_id)
    return if medicines.any? { |medicine| medicine.set_id == med.set_id }
    med.update(name: searchable_medicine.name, active_ingredient: '')
    medicines << med
    save!
  end

  def destroy_medicine(med_name)
    medicines.find { |medicine| medicine.name == med_name }.destroy
  end
end
