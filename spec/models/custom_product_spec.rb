require 'spec_helper'

describe CustomProduct do
  
  before(:each) do
    @prototype = Spree::Prototype.create(:name => "CustomTea")
    @attr = { :name => "Custom Tea Product", :description => "description", :price => 10.99, :prototype_id => @prototype.id }
  end
  
  it "should create a new instance given valid atrtibutes" do
    CustomProduct.create(@attr)
  end
  
  it "should require a prototype" do
    product = CustomProduct.new(:name => "Custom Tea Product", :description => "description", :price => 10.99)
    product.should_not be_valid
  end
end
