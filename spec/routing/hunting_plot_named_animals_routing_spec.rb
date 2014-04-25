require "spec_helper"

describe HuntingPlotNamedAnimalsController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_plot_named_animals").should route_to("hunting_plot_named_animals#index")
    end

    it "routes to #new" do
      get("/hunting_plot_named_animals/new").should route_to("hunting_plot_named_animals#new")
    end

    it "routes to #show" do
      get("/hunting_plot_named_animals/1").should route_to("hunting_plot_named_animals#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_plot_named_animals/1/edit").should route_to("hunting_plot_named_animals#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_plot_named_animals").should route_to("hunting_plot_named_animals#create")
    end

    it "routes to #update" do
      put("/hunting_plot_named_animals/1").should route_to("hunting_plot_named_animals#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_plot_named_animals/1").should route_to("hunting_plot_named_animals#destroy", :id => "1")
    end

  end
end
