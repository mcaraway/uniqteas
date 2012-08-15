require 'spec_helper'

describe CustomProduct do
  
  before(:each) do
    @prototype = Spree::Prototype.create(:name => "CustomTea")
    @attr = { :name => "Custom Tea Product", :description => "description", :price => 10.99 }
  end
  
  it "should create a new instance given valid atrtibutes" do
    CustomProduct.create(@attr)
  end
end
