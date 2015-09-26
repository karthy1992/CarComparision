class CreateVariantfeatures < ActiveRecord::Migration
  def change
    create_table :variantfeatures do |t|
      t.integer :variant_id
      t.integer :feature_id

      t.timestamps null: false
    end
  end
end
