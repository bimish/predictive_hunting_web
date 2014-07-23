require "spec_helper"

describe CompositeNetworkMembersController do
  describe "routing" do

    it "routes to #index" do
      get("/composite_network_member").should route_to("composite_network_member#index")
    end

    it "routes to #new" do
      get("/composite_network_member/new").should route_to("composite_network_member#new")
    end

    it "routes to #show" do
      get("/composite_network_member/1").should route_to("composite_network_member#show", :id => "1")
    end

    it "routes to #edit" do
      get("/composite_network_member/1/edit").should route_to("composite_network_member#edit", :id => "1")
    end

    it "routes to #create" do
      post("/composite_network_member").should route_to("composite_network_member#create")
    end

    it "routes to #update" do
      put("/composite_network_member/1").should route_to("composite_network_member#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/composite_network_member/1").should route_to("composite_network_member#destroy", :id => "1")
    end

  end
end
