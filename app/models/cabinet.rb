class Cabinet < ActiveRecord::Base
  include OpenFdaExtractor
  belongs_to :user
  has_many :cabinet_medicines
  has_many :medicines, through: :cabinet_medicines

  attr_accessor :primary_set_id

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

  def identify_primary(med_name) # method to call when med is newly selected to become primary
    medicine = medicines.find { |med| med.name == med_name }
    rebuild_cabinet
    build_information_regarding_primary(medicine)
  end

  def find_medicine_by_name(med_name)
    medicines.find { |med| med.name == med_name }
  end

  def primary_medicine(session_medicine_id)
    nil if medicines.empty?
    medicine = medicines.find { |med| med.id == session_medicine_id }
    medicine = medicines.first if medicine.nil?
    medicine
  end

  def destroy_medicine(med_name, session_medicine_id) # method to call when med(s) is destroyed
    if med_name.is_a? Hash
      results = medicines.map { |medicine| medicine if med_name.values.include?(medicine.name) }
      medicines.destroy(results.compact)
    else
      medicines.find { |medicine| medicine.name == med_name }.destroy
    end
    reload
    rebuild_cabinet
    build_information_regarding_primary(primary_medicine(session_medicine_id))
  end

  def rebuild_cabinet # loops through all medicines to determine counts of medicines it interacts with
    medicines.each do |current_med|
      interaction_count = 0
      current_med.interaction_count = nil
      medicines.each do |med|
        next if med.set_id == current_med.set_id
        interaction_count += 1 if determine_interaction(current_med, med)
      end
      current_med.interaction_count = interaction_count
    end
  end

  def determine_interaction(med_one, med_two)
    keywords = [med_one.name, med_one.active_ingredient].map { |name| name.try(:downcase) }.uniq
    med_two.interaction_text =~ /#{keywords.reject(&:empty?).join("|")}/ ? true : false
  end

  def build_information_regarding_primary(primary_med)
    primary_med.is_primary = true
    @primary_set_id = primary_med.set_id
    medicines.each do |med|
      next if med.set_id == primary_med.set_id
      me.is_primary = false
      med.is_interacted_with = false
      med.is_interacted_with = true if determine_interaction(primary_med, med) || determine_interaction(med, primary_med)
    end
  end
end
