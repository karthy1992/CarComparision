class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
