class AddLocationToHomePageSliders < ActiveRecord::Migration
  def change
    add_column :spree_home_page_sliders, :location, :string
  end
end
