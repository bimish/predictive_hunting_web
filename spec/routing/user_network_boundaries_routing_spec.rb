require "spec_helper"

describe UserNetworkBoundariesController do
  describe "routing" do

    it "routes to #index" do
      get("/user_network_boundary").should route_to("user_network_boundary#index")
    end

    it "routes to #new" do
      get("/user_network_boundary/new").should route_to("user_network_boundary#new")
    end

    it "routes to #show" do
      get("/user_network_boundary/1").should route_to("user_network_boundary#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_network_boundary/1/edit").should route_to("user_network_boundary#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_network_boundary").should route_to("user_network_boundary#create")
    end

    it "routes to #update" do
      put("/user_network_boundary/1").should route_to("user_network_boundary#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_network_boundary/1").should route_to("user_network_boundary#destroy", :id => "1")
    end

  end
end
