class CreateCabinetMedicine < ActiveRecord::Migration
  def up
    create_table :cabinet_medicines do |t|
      t.belongs_to :cabinet
      t.belongs_to :medicine
      t.timestamps
    end
    remove_foreign_key :medicines, :cabinets
    remove_column :medicines, :cabinet_id
  end

  def down
    drop_table(:cabinet_medicines)
    add_column :medicines, :cabinet_id, :integer
    add_foreign_key :medicines, :cabinets
  end
end
