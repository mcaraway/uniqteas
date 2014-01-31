class Spree::Calculator::FreeShipping < Spree::ShippingCalculator
  #attr_accessible :preferred_amount
  
  def self.description
    "Free Shipping"
  end

  def self.register
    super
    ShippingMethod.register_calculator(self)
  end

  def compute_package(object=nil)
    logger.debug "********* in compute"
    0
  end

  def available?(order)
    available = total(order.contents) >= 50
    logger.debug "********* free shipping available"
    logger.debug "********* free shipping available = " + available.to_s
    logger.debug "********* free shipping available"
    available
  end
end
