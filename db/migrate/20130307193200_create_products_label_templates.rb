class CreateProductsLabelTemplates < ActiveRecord::Migration
  def change    
    create_table :spree_products_label_templates, :id => false, :force => true do |t|
      t.references :product
      t.references :label_template
    end

    add_index :spree_products_label_templates, :product_id, :name => 'index_products_label_templates_on_product_id'
    add_index :spree_products_label_templates, :label_template_id, :name => 'index_products_label_templates_on_label_templates_id'
  end
  
  def down
    drop table :spree_products_label_templates
    drop index :name => 'index_products_label_templates_on_product_id'
    drop index :name => 'index_products_label_templates_on_label_templates_id'
  end
end
