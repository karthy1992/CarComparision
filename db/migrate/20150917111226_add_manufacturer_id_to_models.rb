class AddManufacturerIdToModels < ActiveRecord::Migration
  def change
  	add_column :models, :manufacturer_id, :integer
  end
end
