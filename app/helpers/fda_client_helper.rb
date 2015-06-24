module FdaClientHelper
  def fetch_from_response(response, field_key)
    JSON.parse(response.body)['results'][0][field_key].try(:[], 0) if response.success?
  end
end
