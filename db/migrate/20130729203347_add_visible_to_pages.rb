class AddVisibleToPages < ActiveRecord::Migration
  def change
    add_column :spree_pages, :visible, :boolean
  end
end
