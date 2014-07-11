require "spec_helper"

describe AnimalActivityObservationsController do
  describe "routing" do

    it "routes to #index" do
      get("/animal_activity_observation").should route_to("animal_activity_observation#index")
    end

    it "routes to #new" do
      get("/animal_activity_observation/new").should route_to("animal_activity_observation#new")
    end

    it "routes to #show" do
      get("/animal_activity_observation/1").should route_to("animal_activity_observation#show", :id => "1")
    end

    it "routes to #edit" do
      get("/animal_activity_observation/1/edit").should route_to("animal_activity_observation#edit", :id => "1")
    end

    it "routes to #create" do
      post("/animal_activity_observation").should route_to("animal_activity_observation#create")
    end

    it "routes to #update" do
      put("/animal_activity_observation/1").should route_to("animal_activity_observation#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/animal_activity_observation/1").should route_to("animal_activity_observation#destroy", :id => "1")
    end

  end
end
