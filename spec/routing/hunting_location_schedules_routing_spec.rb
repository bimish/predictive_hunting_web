require "spec_helper"

describe HuntingLocationSchedulesController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_location_schedule").should route_to("hunting_location_schedule#index")
    end

    it "routes to #new" do
      get("/hunting_location_schedule/new").should route_to("hunting_location_schedule#new")
    end

    it "routes to #show" do
      get("/hunting_location_schedule/1").should route_to("hunting_location_schedule#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_location_schedule/1/edit").should route_to("hunting_location_schedule#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_location_schedule").should route_to("hunting_location_schedule#create")
    end

    it "routes to #update" do
      put("/hunting_location_schedule/1").should route_to("hunting_location_schedule#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_location_schedule/1").should route_to("hunting_location_schedule#destroy", :id => "1")
    end

  end
end
