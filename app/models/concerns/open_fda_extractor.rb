module OpenFdaExtractor
  extend ActiveSupport::Concern

  def fetch_string_from_response(response, field_key)
    JSON.parse(response.body)['results'][0][field_key] if response.success?
  end

  def fetch_array_from_response(response, field_key)
    JSON.parse(response.body)['results'][0][field_key].try(:[], 0) if response.success?
  end
end
