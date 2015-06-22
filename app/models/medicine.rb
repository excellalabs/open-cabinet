class Medicine < ActiveRecord::Base
  belongs_to :cabinet

  attr_accessor :warnings, :dosage_and_administration, :description
end
