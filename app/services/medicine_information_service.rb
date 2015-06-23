class MedicineInformationService
  extend FdaClientHelper
  def self.fetch_general_information(set_id)
    response, data = OpenFda::Client.new.query_by_set_id(set_id), {}
    %w(indications_and_usage dosage_and_administration warnings).each { |info| data[info] = fetch_from_response(response, info) }
    data
  end
end
