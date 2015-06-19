class Cabinet < ActiveRecord::Base
  belongs_to :user
  has_many :medicines

  def add_to_cabinet(params)
    med = Medicine.find_or_create_by(set_id: params[:set_id])
    med.name = params[:name] if med.name.empty?
    medicines << med
    save!
  end
end
