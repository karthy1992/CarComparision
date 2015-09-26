class AddModelIdToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :model_id, :integer
  end
end
