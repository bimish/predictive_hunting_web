require "spec_helper"

describe AnimalCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/animal_categories").should route_to("animal_categories#index")
    end

    it "routes to #new" do
      get("/animal_categories/new").should route_to("animal_categories#new")
    end

    it "routes to #show" do
      get("/animal_categories/1").should route_to("animal_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/animal_categories/1/edit").should route_to("animal_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/animal_categories").should route_to("animal_categories#create")
    end

    it "routes to #update" do
      put("/animal_categories/1").should route_to("animal_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/animal_categories/1").should route_to("animal_categories#destroy", :id => "1")
    end

  end
end
