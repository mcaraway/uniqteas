require "spec_helper"

describe LabelTemplatesController do
  describe "routing" do

    it "routes to #index" do
      get("/label_templates").should route_to("label_templates#index")
    end

    it "routes to #new" do
      get("/label_templates/new").should route_to("label_templates#new")
    end

    it "routes to #show" do
      get("/label_templates/1").should route_to("label_templates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/label_templates/1/edit").should route_to("label_templates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/label_templates").should route_to("label_templates#create")
    end

    it "routes to #update" do
      put("/label_templates/1").should route_to("label_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/label_templates/1").should route_to("label_templates#destroy", :id => "1")
    end

  end
end
