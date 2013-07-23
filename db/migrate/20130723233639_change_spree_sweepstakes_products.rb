class ChangeSpreeSweepstakesProducts < ActiveRecord::Migration
  def change
    rename_column :spree_sweepstakes_products, :spree_sweepstakes_id, :sweepstake_id
    rename_column :spree_sweepstakes_products, :spree_products_id, :product_id
  end
end
