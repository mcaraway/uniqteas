Spree::Variant.class_eval do
  def is_custom? 
    sku.start_with?("CUST")
  end
end