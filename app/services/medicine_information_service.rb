class MedicineInformationService
  def self.interactions_text_key
    :interaction_text
  end

  def self.fetch_information(name, cabinet)
    primary, response, client = Medicine.find_by_name(name), {}, OpenFda::Client.new, 0
    response[:primary] = primary.name
    response[:interactions_text] = fetch_array_from_response(client.query_for_interactions(primary), 'drug_interactions')
    %w(indications_and_usage dosage_and_administration warnings).each do |info|
      response[info.to_sym] = fetch_array_from_response(client.query_by_set_id(primary.set_id), info)
    end
    response[:interactions] = build_interactions(primary.set_id, cabinet.medicines, response[:interactions_text])
    response[:all_interactions] = build_bi_directional_interactions(cabinet, client)
    response
  end

  # rubocop:disable Metrics/MethodLength
  def self.find_cabinet_interactions(cabinet, client)
    all_interactions = {}
    medicine_ary = [*cabinet.medicines]
    client.query_for_interactions(medicine_ary).each do |response|
      next unless response.success?
      set_id = fetch_string_from_response(response, 'set_id')
      interaction_text = fetch_array_from_response(response, 'drug_interactions') # interaction text for med
      medicine = medicine_ary.find { |med| med.set_id == set_id }
      all_interactions[medicine.name.to_sym] = build_interactions(set_id, cabinet.medicines, interaction_text)
      all_interactions[medicine.name.to_sym][interactions_text_key] = interaction_text unless all_interactions[medicine.name.to_sym].empty?
    end
    all_interactions
  end

  def self.build_bi_directional_interactions(cabinet, client = OpenFda::Client.new)
    cabinet_interactions = find_cabinet_interactions(cabinet, client)
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

  def self.build_interactions(primary_set_id, medicines, interaction_text)
    data = {}
    medicines.each do |medicine|
      next if primary_set_id == medicine.set_id
      keywords = [medicine.name, medicine.active_ingredient].map { |name| name.try(:downcase) }.uniq
      data[medicine.name.to_sym] = keywords if interaction_text =~ /#{keywords.reject(&:empty?).join("|")}/
    end
    data
  end

  def self.fetch_string_from_response(response, field_key)
    JSON.parse(response.body)['results'][0][field_key] if response.success?
  end

  def self.fetch_array_from_response(response, field_key)
    JSON.parse(response.body)['results'][0][field_key].try(:[], 0) if response.success?
  end
end
