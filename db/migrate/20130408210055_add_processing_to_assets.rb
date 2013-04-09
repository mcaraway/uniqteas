class AddProcessingToAssets < ActiveRecord::Migration
  def change
    add_column :spree_assets, :processing, :boolean
  end
  
  def down
    remove_column :spree_assets, :processing
  end
end
