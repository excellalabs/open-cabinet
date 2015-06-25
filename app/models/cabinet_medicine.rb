class CabinetMedicine < ActiveRecord::Base
  belongs_to :cabinet
  belongs_to :medicine
  default_scope  { order(created_at: :desc) }
end
