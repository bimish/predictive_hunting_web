require "spec_helper"

describe UserNetworkSubscriptionsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_network_subscription").should route_to("user_network_subscription#index")
    end

    it "routes to #new" do
      get("/user_network_subscription/new").should route_to("user_network_subscription#new")
    end

    it "routes to #show" do
      get("/user_network_subscription/1").should route_to("user_network_subscription#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_network_subscription/1/edit").should route_to("user_network_subscription#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_network_subscription").should route_to("user_network_subscription#create")
    end

    it "routes to #update" do
      put("/user_network_subscription/1").should route_to("user_network_subscription#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_network_subscription/1").should route_to("user_network_subscription#destroy", :id => "1")
    end

  end
end
