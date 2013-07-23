require "spec_helper"

describe SweepstakesController do
  describe "routing" do

    it "routes to #index" do
      get("/sweepstakes").should route_to("sweepstakes#index")
    end

    it "routes to #new" do
      get("/sweepstakes/new").should route_to("sweepstakes#new")
    end

    it "routes to #show" do
      get("/sweepstakes/1").should route_to("sweepstakes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sweepstakes/1/edit").should route_to("sweepstakes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sweepstakes").should route_to("sweepstakes#create")
    end

    it "routes to #update" do
      put("/sweepstakes/1").should route_to("sweepstakes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sweepstakes/1").should route_to("sweepstakes#destroy", :id => "1")
    end

  end
end
