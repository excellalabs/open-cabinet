class Medicine < ActiveRecord::Base
  include OpenFdaExtractor
  has_many :cabinet_medicines
  has_many :cabinets, through: :cabinet_medicines
  default_scope  { includes(:cabinet_medicines).order('cabinet_medicines.created_at DESC') }

  after_initialize :init

  def self.attr_list
    [:warnings, :dosage_and_administration, :indications_and_usage, :drug_interactions, :interactions]
  end

  attr_accessor(*attr_list)

  def init
    client = OpenFda::Client.new
    response = client.query_by_set_id(set_id)

    Medicine.attr_list.each do |field|
      send("#{field}=", fetch_array_from_response(response, field.to_s))
    end

    @interactions ||= []
  end

  def interaction_names
    interactions.collect(&:name).uniq
  end

  def interaction_count
    interactions.length
  end

  def interaction?
    interaction_count > 0
  end

  def interacts_with(medicine)
    interaction_names.include? medicine.try(:name)
  end
end
