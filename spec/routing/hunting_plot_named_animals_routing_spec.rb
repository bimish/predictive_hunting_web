require "spec_helper"

describe HuntingPlotNamedAnimalsController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_plot_named_animal").should route_to("hunting_plot_named_animal#index")
    end

    it "routes to #new" do
      get("/hunting_plot_named_animal/new").should route_to("hunting_plot_named_animal#new")
    end

    it "routes to #show" do
      get("/hunting_plot_named_animal/1").should route_to("hunting_plot_named_animal#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_plot_named_animal/1/edit").should route_to("hunting_plot_named_animal#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_plot_named_animal").should route_to("hunting_plot_named_animal#create")
    end

    it "routes to #update" do
      put("/hunting_plot_named_animal/1").should route_to("hunting_plot_named_animal#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_plot_named_animal/1").should route_to("hunting_plot_named_animal#destroy", :id => "1")
    end

  end
end
