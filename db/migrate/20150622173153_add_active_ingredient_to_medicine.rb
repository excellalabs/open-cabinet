class AddActiveIngredientToMedicine < ActiveRecord::Migration
  def change
    add_column :medicines, :active_ingredient, :string 
  end
end
