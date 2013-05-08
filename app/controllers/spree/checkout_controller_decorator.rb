Spree::CheckoutController.class_eval do
  
  def current_user
    try_spree_current_user
  end
end