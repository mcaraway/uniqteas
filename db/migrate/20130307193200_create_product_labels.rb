class CreateProductLabels < ActiveRecord::Migration
  def change
    create_table :spree_product_labels do |t|
      t.string :name
      t.string :group
      t.integer :label_template_id
      t.integer :product_id
      t.string :label_image_file_name
      t.string :label_image_content_type
      t.string :label_image_remote_url
      t.integer :label_image_width
      t.integer :label_image_height
      t.integer :label_image_size
      t.timestamp :label_image_updated_at
      t.timestamps
    end
  end
  
  def down
    drop_table :spree_product_labels
  end
end