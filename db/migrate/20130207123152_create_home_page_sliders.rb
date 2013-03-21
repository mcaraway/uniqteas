class CreateHomePageSliders < ActiveRecord::Migration
  def change
    create_table :spree_home_page_sliders do |t|
      t.string :name
      t.string :html

      t.timestamps
    end
  end
  
  def down
    drop table :spree_home_page_sliders
  end
end
