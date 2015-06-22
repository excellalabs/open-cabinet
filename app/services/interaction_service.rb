class InteractionService
  def self.fetch_all_interactions(set_id, cabinet)
    primary, response = Medicine.find_by_set_id(set_id), {}
    response['interactions_text'] = clean_interaction_response(OpenFda::Client.new.query_for_interactions(primary))
    response['interactions'] = {}

    cabinet.medicines.each do |medicine|
      response['interactions']["#{medicine.set_id}"] = [medicine.name, medicine.active_ingredient] unless primary.set_id == medicine.set_id
    end
    response
  end

  def self.clean_interaction_response(response)
    JSON.parse(response.body)['results'][0]['drug_interactions'][0] if response.success?
  end
end
