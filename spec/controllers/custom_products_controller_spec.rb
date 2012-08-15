require 'spec_helper'

describe CustomProductsController do
  render_views
  
  describe "GET 'new'" do
      before(:each) do
        @prototype = Spree::Prototype.create(:name => "CustomTea")
      end
    
    it "should be successful" do
      get :new
      response.should be_success
     end
     
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      before(:each) do
        @prototype = Spree::Prototype.create(:name => "CustomTea")
        @attr = { :name => "", :description => ""}
      end
      
      it "should not create a custom_product" do
        lambda do
          post :create, :custom_product => @attr
        end.should_not change(CustomProduct, :count)
      end
      
      it "should render the 'new' page" do
          post :create, :custom_product => @attr
          response.should render_template('new')
      end
    end
    
    describe "success" do
      before(:each) do
        @prototype = Spree::Prototype.create(:name => "CustomTea")
        @attr = { :name => "Custom Tea Product", :description => "description", :price => 10.99 }
      end
      
      it "should create a custom product" do
        lambda do
          post :create, :custom_product => @attr
        end.should change(CustomProduct, :count).by(1)
      end
      
      it "should redirect to the custom product show page" do
        post :create, :custom_product => @attr
        response.should redirect_to(custom_product_path(assigns(:custom_product)))
      end
      
      it "should have a success message" do
        post :create, :custom_product => @attr
        flash[:success].should =~ /Your product is good to go/i
      end
    end
  end
end
