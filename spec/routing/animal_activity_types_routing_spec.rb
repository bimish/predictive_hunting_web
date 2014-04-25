require "spec_helper"

describe AnimalActivityTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/animal_activity_types").should route_to("animal_activity_types#index")
    end

    it "routes to #new" do
      get("/animal_activity_types/new").should route_to("animal_activity_types#new")
    end

    it "routes to #show" do
      get("/animal_activity_types/1").should route_to("animal_activity_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/animal_activity_types/1/edit").should route_to("animal_activity_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/animal_activity_types").should route_to("animal_activity_types#create")
    end

    it "routes to #update" do
      put("/animal_activity_types/1").should route_to("animal_activity_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/animal_activity_types/1").should route_to("animal_activity_types#destroy", :id => "1")
    end

  end
end
