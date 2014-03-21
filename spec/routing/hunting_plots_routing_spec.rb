require "spec_helper"

describe HuntingPlotsController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_plots").should route_to("hunting_plots#index")
    end

    it "routes to #new" do
      get("/hunting_plots/new").should route_to("hunting_plots#new")
    end

    it "routes to #show" do
      get("/hunting_plots/1").should route_to("hunting_plots#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_plots/1/edit").should route_to("hunting_plots#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_plots").should route_to("hunting_plots#create")
    end

    it "routes to #update" do
      put("/hunting_plots/1").should route_to("hunting_plots#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_plots/1").should route_to("hunting_plots#destroy", :id => "1")
    end

  end
end
