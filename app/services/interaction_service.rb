class InteractionService
  extend FdaClientHelper
  def self.fetch_all_interactions(set_id, cabinet)
    primary, response = Medicine.find_by_set_id(set_id), {}
    response['interactions_text'] = fetch_from_response(OpenFda::Client.new.query_for_interactions(primary), 'drug_interactions')
    response['interactions'] = {}

    cabinet.medicines.each do |medicine|
      response['interactions']["#{medicine.set_id}"] = [medicine.name, medicine.active_ingredient] unless primary.set_id == medicine.set_id
    end
    response
  end
end
