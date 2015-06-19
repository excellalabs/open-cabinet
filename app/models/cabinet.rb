class Cabinet < ActiveRecord::Base
  belongs_to :user
  has_many :medicines
end
