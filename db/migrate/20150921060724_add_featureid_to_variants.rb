class AddFeatureidToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :featureid, :integer
  end
end
