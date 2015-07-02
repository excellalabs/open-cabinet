class Medicine < ActiveRecord::Base
  include OpenFdaExtractor
  has_many :cabinet_medicines
  has_many :cabinets, through: :cabinet_medicines
  default_scope  { includes(:cabinet_medicines).order('cabinet_medicines.created_at DESC') }

  attr_accessor :warnings, :dosage_and_administration, :indications_and_usage, :interactions_text

  def fetch_information
    client = OpenFda::Client.new
    response = client.query_by_set_id(set_id)
    @warnings = fetch_array_from_response(response, 'warnings')
    @dosage_and_administration = fetch_array_from_response(response, 'dosage_and_administration')
    @indications_and_usage = fetch_array_from_response(response, 'indications_and_usage')
  end

  def fetch_interactions_text
    client = OpenFda::Client.new
    @interactions_text = fetch_array_from_response(client.query_for_interactions(self), 'drug_interactions')
  end
end
