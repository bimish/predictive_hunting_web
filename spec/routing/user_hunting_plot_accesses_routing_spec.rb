require "spec_helper"

describe UserHuntingPlotAccessesController do
  describe "routing" do

    it "routes to #index" do
      get("/user_hunting_plot_accesses").should route_to("user_hunting_plot_accesses#index")
    end

    it "routes to #new" do
      get("/user_hunting_plot_accesses/new").should route_to("user_hunting_plot_accesses#new")
    end

    it "routes to #show" do
      get("/user_hunting_plot_accesses/1").should route_to("user_hunting_plot_accesses#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_hunting_plot_accesses/1/edit").should route_to("user_hunting_plot_accesses#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_hunting_plot_accesses").should route_to("user_hunting_plot_accesses#create")
    end

    it "routes to #update" do
      put("/user_hunting_plot_accesses/1").should route_to("user_hunting_plot_accesses#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_hunting_plot_accesses/1").should route_to("user_hunting_plot_accesses#destroy", :id => "1")
    end

  end
end
