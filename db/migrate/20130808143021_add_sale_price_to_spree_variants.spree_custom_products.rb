# This migration comes from spree_custom_products (originally 20130601163746)
class AddSalePriceToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :sale_price, :decimal
  end
end
