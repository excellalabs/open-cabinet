class SetIdSearchableMed < ActiveRecord::Migration
  def up
    add_column :searchable_medicines, :set_id, :string
  end

  def down
    remove_column :searchable_medicines, :set_id
  end
end
