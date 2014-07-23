require "spec_helper"

describe UserNetworksController do
  describe "routing" do

    it "routes to #index" do
      get("/user_network").should route_to("user_network#index")
    end

    it "routes to #new" do
      get("/user_network/new").should route_to("user_network#new")
    end

    it "routes to #show" do
      get("/user_network/1").should route_to("user_network#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_network/1/edit").should route_to("user_network#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_network").should route_to("user_network#create")
    end

    it "routes to #update" do
      put("/user_network/1").should route_to("user_network#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_network/1").should route_to("user_network#destroy", :id => "1")
    end

  end
end
