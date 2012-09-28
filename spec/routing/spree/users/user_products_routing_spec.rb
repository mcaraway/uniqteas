require "spec_helper"

describe UserProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_products").should route_to("user_products#index")
    end

    it "routes to #new" do
      get("/user_products/new").should route_to("user_products#new")
    end

    it "routes to #show" do
      get("/user_products/1").should route_to("user_products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_products/1/edit").should route_to("user_products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_products").should route_to("user_products#create")
    end

    it "routes to #update" do
      put("/user_products/1").should route_to("user_products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_products/1").should route_to("user_products#destroy", :id => "1")
    end

  end
end
