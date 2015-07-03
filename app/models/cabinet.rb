class Cabinet < ActiveRecord::Base
  include OpenFdaExtractor
  belongs_to :user
  has_many :cabinet_medicines
  has_many :medicines, through: :cabinet_medicines
  attr_accessor :primary_medicine

  def find_medicine_by_name(med_name)
    medicines.find { |med| med.name == med_name }
  end

  def find_medicine_by_set_id(set_id)
    medicines.find { |med| med.set_id == set_id }
  end

  def add_to_cabinet(searchable_medicine) # method to call when med gets added to cabinet
    return if searchable_medicine.nil?
    med = Medicine.find_or_create_by(set_id: searchable_medicine.set_id)
    return if medicines.any? { |medicine| medicine.set_id == med.set_id }
    med.update(name: searchable_medicine.name, active_ingredient: '')
    medicines << med
    save!
    rebuild_cabinet
    build_information_regarding_primary(med)
  end

  # method to call when med is newly selected to become primary
  def identify_primary(med_name)
    medicine = find_medicine_by_name(med_name)
    medicine = medicines.first if medicine.nil?
    rebuild_cabinet
    build_information_regarding_primary(medicine)
  end

  def determine_primary_medicine(session_medicine_id)
    nil if medicines.empty?
    medicine = find_medicine_by_set_id(session_medicine_id)
    medicine = medicines.first if medicine.nil?
    medicine
  end

  def destroy_medicine(med_name, session_medicine_id) # method to call when med(s) is destroyed
    if med_name.is_a? Hash
      results = medicines.map { |medicine| medicine if med_name.values.include?(medicine.name) }
      medicines.destroy(results.compact)
    else
      find_medicine_by_name(med_name).destroy
    end
    reload
    rebuild_cabinet
    build_information_regarding_primary(determine_primary_medicine(session_medicine_id))
  end

  # loops through all medicines to determine counts of medicines it interacts with
  def rebuild_cabinet
    medicines.each do |current_med|
      medicines.each do |med|
        next if med.set_id == current_med.set_id
        if determine_interaction(current_med, med)
          med.interactions |= [current_med]
          current_med.interactions |= [med]
        end
      end
    end
  end

  def determine_interaction(med_one, med_two)
    keywords = [med_one.name, med_one.active_ingredient].map { |name| name.try(:downcase) }.uniq
    med_two.drug_interactions.to_s =~ /#{keywords.reject(&:empty?).join("|")}/ ? true : false
  end

  def build_information_regarding_primary(primary_med)
    @primary_medicine = primary_med if primary_med
  end
end
