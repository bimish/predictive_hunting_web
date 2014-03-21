require "spec_helper"

describe HuntingLocationsController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_locations").should route_to("hunting_locations#index")
    end

    it "routes to #new" do
      get("/hunting_locations/new").should route_to("hunting_locations#new")
    end

    it "routes to #show" do
      get("/hunting_locations/1").should route_to("hunting_locations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_locations/1/edit").should route_to("hunting_locations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_locations").should route_to("hunting_locations#create")
    end

    it "routes to #update" do
      put("/hunting_locations/1").should route_to("hunting_locations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_locations/1").should route_to("hunting_locations#destroy", :id => "1")
    end

  end
end
