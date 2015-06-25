class Medicine < ActiveRecord::Base
  belongs_to :cabinet
  default_scope  { order(created_at: :desc) }

  attr_accessor :warnings, :dosage_and_administration, :description
end
