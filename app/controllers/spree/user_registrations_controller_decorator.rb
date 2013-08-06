Spree::UserRegistrationsController.class_eval do
  after_filter :move_products, :only => :create

  def move_products
    guest_user_id = session['guest_user']
    if guest_user_id 
      guest_user = Spree::User.find_by_id(guest_user_id.to_i)
      
      guest_user.move_to(try_spree_current_user) unless guest_user == try_spree_current_user
    end
  end
end