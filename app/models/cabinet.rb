class Cabinet < ActiveRecord::Base
  belongs_to :user
  has_many :cabinet_medicines
  has_many :medicines, through: :cabinet_medicines

  def add_to_cabinet(searchable_medicine)
    return if searchable_medicine.nil?
    med = Medicine.find_or_create_by(set_id: searchable_medicine.set_id)
    return if medicines.any? { |medicine| medicine.set_id == med.set_id }
    med.update(name: searchable_medicine.name, active_ingredient: '')
    medicines << med
    save!
    med
  end

  def find_medicine_by_name(med_name)
    medicines.find { |medicine| medicine.name == med_name }
  end

  def primary_medicine(session_medicine_id)
    nil if medicines.empty?
    medicine = medicines.find { |med| med.id == session_medicine_id }
    medicine = medicines.first if medicine.nil?
    medicine
  end

  def destroy_medicine(med_name)
    if med_name.is_a? Hash
      results = medicines.map { |medicine| medicine if med_name.values.include?(medicine.name) }
      medicines.destroy(results.compact)
    else
      medicines.find { |medicine| medicine.name == med_name }.destroy
    end
    reload
  end
end
