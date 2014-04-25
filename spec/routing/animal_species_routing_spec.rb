require "spec_helper"

describe AnimalSpeciesController do
  describe "routing" do

    it "routes to #index" do
      get("/animal_species").should route_to("animal_species#index")
    end

    it "routes to #new" do
      get("/animal_species/new").should route_to("animal_species#new")
    end

    it "routes to #show" do
      get("/animal_species/1").should route_to("animal_species#show", :id => "1")
    end

    it "routes to #edit" do
      get("/animal_species/1/edit").should route_to("animal_species#edit", :id => "1")
    end

    it "routes to #create" do
      post("/animal_species").should route_to("animal_species#create")
    end

    it "routes to #update" do
      put("/animal_species/1").should route_to("animal_species#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/animal_species/1").should route_to("animal_species#destroy", :id => "1")
    end

  end
end
