class AddModelIdToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :model_id, :integer
  end
end
