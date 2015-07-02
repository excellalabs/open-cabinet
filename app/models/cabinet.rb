class Cabinet < ActiveRecord::Base
  include OpenFdaExtractor
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

  def self.find_cabinet_interactions
    all_interactions, client = {}, OpenFda::Client.new
    client.query_for_interactions(medicines).each do |response|
      next unless response.success?
      set_id = fetch_string_from_response(response, 'set_id')
      interaction_text = fetch_array_from_response(response, 'drug_interactions') # interaction text for med
      medicine = medicines.find { |med| med.set_id == set_id }
      all_interactions[medicine.name.to_sym] = build_interactions(set_id, interaction_text)
      all_interactions[medicine.name.to_sym][interactions_text_key] = interaction_text unless all_interactions[medicine.name.to_sym].empty?
    end
    all_interactions
  end

  def self.build_bi_directional_interactions
    cabinet_interactions = find_cabinet_interactions
    result = cabinet_interactions.deep_dup
    cabinet_interactions.each do |name_symbol, interactions_hash|
      interactions_hash.each do |interaction_symbol, _data|
        result[interaction_symbol] = {} unless result.key?(interaction_symbol)
        next if result[interaction_symbol].key?(name_symbol)
        result[interaction_symbol][name_symbol] = [name_symbol.to_s.downcase]
      end
    end
    result
  end

  def self.build_interactions(primary_set_id, interaction_text)
    data = {}
    medicines.each do |medicine|
      next if primary_set_id == medicine.set_id
      keywords = [medicine.name, medicine.active_ingredient].map { |name| name.try(:downcase) }.uniq
      data[medicine.name.to_sym] = keywords if interaction_text =~ /#{keywords.reject(&:empty?).join("|")}/
    end
    data
  end
end
