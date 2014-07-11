require "spec_helper"

describe HuntingLocationsController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_location").should route_to("hunting_location#index")
    end

    it "routes to #new" do
      get("/hunting_location/new").should route_to("hunting_location#new")
    end

    it "routes to #show" do
      get("/hunting_location/1").should route_to("hunting_location#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_location/1/edit").should route_to("hunting_location#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_location").should route_to("hunting_location#create")
    end

    it "routes to #update" do
      put("/hunting_location/1").should route_to("hunting_location#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_location/1").should route_to("hunting_location#destroy", :id => "1")
    end

  end
end
