class MedicineInformationService
  extend FdaClientHelper
  def self.fetch_information(name, cabinet)
    @primary, response, client = Medicine.find_by_name(name), {}, OpenFda::Client.new, 0
    response[:primary] = @primary.name
    response[:interactions_text] = fetch_from_response(client.query_for_interactions(@primary), 'drug_interactions')
    %w(indications_and_usage dosage_and_administration warnings).each do |info|
      response[info.to_sym] = fetch_from_response(client.query_by_set_id(@primary.set_id), info)
    end
    response[:interactions] = build_interactions(cabinet.medicines, response[:interactions_text])
    response
  end

  def self.build_interactions(medicines, interaction_text)
    data = {}
    medicines.each do |medicine|
      next if @primary.set_id == medicine.set_id
      keywords = [medicine.name, medicine.active_ingredient].map { |name| name.try(:downcase) }.uniq
      data[medicine.name.to_sym] = keywords if interaction_text =~ /#{keywords.reject(&:empty?).join("|")}/
    end
    data
  end
end
