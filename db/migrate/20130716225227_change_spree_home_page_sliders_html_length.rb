class ChangeSpreeHomePageSlidersHtmlLength < ActiveRecord::Migration
  def change
    change_column :spree_home_page_sliders, :html, :text
  end
end
