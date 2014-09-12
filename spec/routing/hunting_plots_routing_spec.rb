require "spec_helper"

describe HuntingPlotsController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_plot").should route_to("hunting_plot#index")
    end

    it "routes to #new" do
      get("/hunting_plot/new").should route_to("hunting_plot#new")
    end

    it "routes to #show" do
      get("/hunting_plot/1").should route_to("hunting_plot#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_plot/1/edit").should route_to("hunting_plot#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_plot").should route_to("hunting_plot#create")
    end

    it "routes to #update" do
      put("/hunting_plot/1").should route_to("hunting_plot#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_plot/1").should route_to("hunting_plot#destroy", :id => "1")
    end

  end
end
