require "spec_helper"

describe UserGroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_group").should route_to("user_group#index")
    end

    it "routes to #new" do
      get("/user_group/new").should route_to("user_group#new")
    end

    it "routes to #show" do
      get("/user_group/1").should route_to("user_group#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_group/1/edit").should route_to("user_group#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_group").should route_to("user_group#create")
    end

    it "routes to #update" do
      put("/user_group/1").should route_to("user_group#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_group/1").should route_to("user_group#destroy", :id => "1")
    end

  end
end
