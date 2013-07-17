class ChangeSpreePagesHtmlLength < ActiveRecord::Migration
  def up
    change_column :spree_pages, :html, :text
  end

  def down
  end
end
