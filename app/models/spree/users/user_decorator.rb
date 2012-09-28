Spree::User.class_eval do
  
  has_and_belongs_to_many :custom_products, :class_name => "Spree::Product", :join_table => 'user_products', :foreign_key => 'user_id'
  
  attr_accessible :custom_products
  
end