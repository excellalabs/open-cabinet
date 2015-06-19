class DrugToMedicine < ActiveRecord::Migration
  def change
    rename_table :searchable_drugs, :searchable_medicines
  end
end
