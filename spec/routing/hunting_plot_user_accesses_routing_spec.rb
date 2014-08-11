require "spec_helper"

describe HuntingPlotUserAccessesController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_plot_user_access").should route_to("hunting_plot_user_access#index")
    end

    it "routes to #new" do
      get("/hunting_plot_user_access/new").should route_to("hunting_plot_user_access#new")
    end

    it "routes to #show" do
      get("/hunting_plot_user_access/1").should route_to("hunting_plot_user_access#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_plot_user_access/1/edit").should route_to("hunting_plot_user_access#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_plot_user_access").should route_to("hunting_plot_user_access#create")
    end

    it "routes to #update" do
      put("/hunting_plot_user_access/1").should route_to("hunting_plot_user_access#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_plot_user_access/1").should route_to("hunting_plot_user_access#destroy", :id => "1")
    end

  end
end
