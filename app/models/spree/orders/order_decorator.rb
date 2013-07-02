Spree::Order.class_eval do
  def eligible_for_free_shipping?
    self.item_total.to_i >= 50
  end
end