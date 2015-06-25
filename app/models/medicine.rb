class Medicine < ActiveRecord::Base
  has_many :cabinet_medicines
  has_many :cabinets, through: :cabinet_medicines
  default_scope  { includes(:cabinet_medicines).order('cabinet_medicines.created_at DESC') }

  attr_accessor :warnings, :dosage_and_administration, :description
end
