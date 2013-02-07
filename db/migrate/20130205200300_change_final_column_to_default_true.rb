class ChangeFinalColumnToDefaultTrue < ActiveRecord::Migration
 
  def change
    change_column :spree_products, :final, :boolean, :default => true
  end
  
  def down
    change_column :spree_products, :final, :boolean, :default => false
  end
end
