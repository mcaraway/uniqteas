Spree::User.class_eval do
  #has_and_belongs_to_many :products, :class_name => "Spree::Product", :join_table => 'user_products', :foreign_key => 'user_id'
  has_many :products
  
  def myproducts
    myproducts = []
    
    products.each do |product|
      if product.deleted_at == nil
        myproducts << product
      end
    end
    myproducts
  end
  
  def self.create_guest_user
    new { |u| u.guest = true; 
      u.email = get_guest_email; 
      u.password = (0...8).map{(65+rand(26)).chr}.join;
      u.password_confirmation = u.password }
  end
  
  def move_to(user)
    products.update_all(user_id: user.id)
  end
  
  private
  
  def self.get_guest_email
    "guest"+ Spree::User.all.size.to_s+"@guest.com"
  end
end