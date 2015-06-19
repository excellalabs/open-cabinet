class InitialDataModel < ActiveRecord::Migration
  def up
    create_table(:cabinets) do |t|
      t.belongs_to :user, index: true
      t.timestamps
    end

    create_table(:medicines) do |t|
      t.belongs_to :cabinet, index: true
      t.string :set_id, null: false, default: ""
      t.string :name, null: false, default: ""
      t.timestamps
    end

    add_index :medicines, :set_id
    add_index :medicines, :name

    add_foreign_key :cabinets, :users
    add_foreign_key :medicines, :cabinets
  end

  def down
    drop_table(:cabinets)
    drop_table(:medicines)
  end
end
