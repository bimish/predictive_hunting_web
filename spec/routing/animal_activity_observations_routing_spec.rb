require "spec_helper"

describe AnimalActivityObservationsController do
  describe "routing" do

    it "routes to #index" do
      get("/animal_activity_observations").should route_to("animal_activity_observations#index")
    end

    it "routes to #new" do
      get("/animal_activity_observations/new").should route_to("animal_activity_observations#new")
    end

    it "routes to #show" do
      get("/animal_activity_observations/1").should route_to("animal_activity_observations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/animal_activity_observations/1/edit").should route_to("animal_activity_observations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/animal_activity_observations").should route_to("animal_activity_observations#create")
    end

    it "routes to #update" do
      put("/animal_activity_observations/1").should route_to("animal_activity_observations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/animal_activity_observations/1").should route_to("animal_activity_observations#destroy", :id => "1")
    end

  end
end
