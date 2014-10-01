require "spec_helper"

describe HuntingPlotUserAccessRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_plot_user_access_request").should route_to("hunting_plot_user_access_request#index")
    end

    it "routes to #new" do
      get("/hunting_plot_user_access_request/new").should route_to("hunting_plot_user_access_request#new")
    end

    it "routes to #show" do
      get("/hunting_plot_user_access_request/1").should route_to("hunting_plot_user_access_request#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_plot_user_access_request/1/edit").should route_to("hunting_plot_user_access_request#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_plot_user_access_request").should route_to("hunting_plot_user_access_request#create")
    end

    it "routes to #update" do
      put("/hunting_plot_user_access_request/1").should route_to("hunting_plot_user_access_request#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_plot_user_access_request/1").should route_to("hunting_plot_user_access_request#destroy", :id => "1")
    end

  end
end
