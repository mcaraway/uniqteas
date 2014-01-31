class CreateDefaultShippingCategory < ActiveRecord::Migration
  def change
    create_table :default_shipping_categories do |t|
      default_category = Spree::ShippingCategory.first
      default_category ||= Spree::ShippingCategory.create!(:name => "Default")
    
      Spree::ShippingMethod.all.each do |method|
        method.shipping_categories << default_category if method.shipping_categories.blank?
      end
    
      Spree::Product.where(shipping_category_id: nil).update_all(shipping_category_id: default_category.id)      
    end
  end
end
