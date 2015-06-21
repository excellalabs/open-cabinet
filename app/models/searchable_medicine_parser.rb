class SearchableMedicineParser
  include ActiveModel::Model
  # query for labels every 60 days
  TIME_STEP = 60 * 60 * 24 * 60

  def initialize(key, writer)
    @client = OpenFda::Client.new(api_key: key)
    @output_writer = writer
  end

  def pull_searchable_medicines(start_time, finish_time)
    Rails.logger.info 'Beginning import...'
    names = pull_for_time_period(start_time, finish_time)
    data = names.keys.select { |key| key.length > 0 }
    @output_writer.write(data)
  end

  private

  def pull_for_time_period(start_time, finish_time)
    names = {}
    while start_time < finish_time
      end_time = start_time + TIME_STEP
      names.merge!(parse_for_time_step(start_time, end_time))
      start_time = end_time
    end
    names
  end

  def parse_for_time_step(start_time, end_time)
    skip = 0
    result = {}
    loop do
      data = load_json(skip, start_time, end_time)
      result.merge!(tabulate_medicine_names(data))
      skip += OpenFda::Client::MAX_LIMIT
      break if data.keys.length == 0 || data['results'].length < OpenFda::Client::MAX_LIMIT
    end
    Rails.logger.info 'Found ' + result.keys.length.to_s + ' records for ' + start_time.strftime('%m/%d/%Y')
    result
  end

  def load_json(skip, start_time, end_time)
    sleep 1
    response = @client.query_by_time_period(start_time, end_time, OpenFda::Client::MAX_LIMIT, skip)
    return {} if response.status == 404
    JSON.parse(response.body)
  end

  def tabulate_medicine_names(data)
    return {} if data.keys.length == 0
    begin
      return parse_names(data)
    rescue => ex
      Rails.logger.error data.inspect
      raise ex
    end
  end

  def parse_names(data)
    tabulation = {}
    data['results'].each do |result|
      tabulation.merge!(split_names(result['openfda']['generic_name']))
      tabulation.merge!(split_names(result['openfda']['brand_name']))
    end
    tabulation
  end

  def split_names(names)
    return {} if names.nil?
    result = {}
    all_names = []
    names.each do |name|
      all_names.push(*name.split(','))
    end
    all_names.each { |name| result[sanitize(name)] = sanitize(name) }
    result
  end

  def sanitize(str)
    str.strip!
    str.upcase!
    str.slice!('AND ') if str.start_with?('AND ')
    str.titleize
  end
end
