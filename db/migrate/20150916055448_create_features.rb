class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :featurename
      t.integer :featuretype

      t.timestamps null: false
    end
  end
end
