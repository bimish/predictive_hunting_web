require "spec_helper"

describe UserNetworkCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/user_network_category").should route_to("user_network_category#index")
    end

    it "routes to #new" do
      get("/user_network_category/new").should route_to("user_network_category#new")
    end

    it "routes to #show" do
      get("/user_network_category/1").should route_to("user_network_category#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_network_category/1/edit").should route_to("user_network_category#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_network_category").should route_to("user_network_category#create")
    end

    it "routes to #update" do
      put("/user_network_category/1").should route_to("user_network_category#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_network_category/1").should route_to("user_network_category#destroy", :id => "1")
    end

  end
end
