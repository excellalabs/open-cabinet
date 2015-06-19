class AddTableForDrugNames < ActiveRecord::Migration
  def change
    create_table(:searchable_drugs) do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :searchable_drugs, :name, unique: true
  end
end
