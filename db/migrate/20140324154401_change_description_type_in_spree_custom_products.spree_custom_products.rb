# This migration comes from spree_custom_products (originally 20140324190612)
class ChangeDescriptionTypeInSpreeCustomProducts < ActiveRecord::Migration
  def change
    change_column :spree_custom_products, :description, :text
  end
  
  def down
    change_column :spree_custom_products, :description, :string
  end
end
