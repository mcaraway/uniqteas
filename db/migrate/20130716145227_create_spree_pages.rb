class CreateSpreePages < ActiveRecord::Migration
  def change
    create_table :spree_pages do |t|
      t.string :name
      t.string :permalink
      t.string :html
      t.string :page_title
      t.string :meta_keywords
      t.string :meta_description
      t.string :search_keywords

      t.timestamps
    end
  end
end
