class AddFeaturecategoryToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :featurecategory, :string
  end
end
