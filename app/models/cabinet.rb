class Cabinet < ActiveRecord::Base
  include OpenFdaExtractor
  belongs_to :user
  has_many :cabinet_medicines
  has_many :medicines, through: :cabinet_medicines

  def find_medicine_by_name(med_name)
    medicines.find { |med| med.name == med_name }
  end

  def find_medicine_by_set_id(set_id)
    medicines.find { |med| med.set_id == set_id } || medicines.first
  end

  def add_to_cabinet(searchable_medicine) # method to call when med gets added to cabinet
    return if searchable_medicine.nil?
    med = Medicine.find_or_create_by(set_id: searchable_medicine.set_id)
    return if medicines.any? { |medicine| medicine.set_id == med.set_id }
    med.update(name: searchable_medicine.name, active_ingredient: '')
    medicines << med
    save!
    reload
    med
  end

  # method to call when med is newly selected to become primary
  def identify_primary(med_name)
    medicine = find_medicine_by_name(med_name)
    medicine = medicines.first if medicine.nil?
    rebuild_cabinet
    medicine
  end

  def destroy_medicine(med_name) # method to call when med(s) is destroyed
    if med_name.is_a? Hash
      results = medicines.map { |medicine| medicine if med_name.values.include?(medicine.name) }
      medicines.destroy(results.compact)
    else
      find_medicine_by_name(med_name).destroy
    end
    reload
  end

  # loops through all medicines to determine counts of medicines it interacts with
  def rebuild_cabinet
    medicines.each do |med1|
      medicines.each do |med2|
        next if med1.set_id == med2.set_id
        Medicine.set_interactions(med1, med2)
      end
    end
  end
end
