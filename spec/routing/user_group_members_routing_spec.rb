require "spec_helper"

describe UserGroupMembersController do
  describe "routing" do

    it "routes to #index" do
      get("/user_group_member").should route_to("user_group_member#index")
    end

    it "routes to #new" do
      get("/user_group_member/new").should route_to("user_group_member#new")
    end

    it "routes to #show" do
      get("/user_group_member/1").should route_to("user_group_member#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_group_member/1/edit").should route_to("user_group_member#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_group_member").should route_to("user_group_member#create")
    end

    it "routes to #update" do
      put("/user_group_member/1").should route_to("user_group_member#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_group_member/1").should route_to("user_group_member#destroy", :id => "1")
    end

  end
end
