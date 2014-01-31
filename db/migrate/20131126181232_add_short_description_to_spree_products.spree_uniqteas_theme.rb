# This migration comes from spree_uniqteas_theme (originally 20130807192418)
class AddShortDescriptionToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :short_description, :text
  end
end
