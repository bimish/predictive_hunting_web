require "spec_helper"

describe UserRelationshipsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_relationship").should route_to("user_relationship#index")
    end

    it "routes to #new" do
      get("/user_relationship/new").should route_to("user_relationship#new")
    end

    it "routes to #show" do
      get("/user_relationship/1").should route_to("user_relationship#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_relationship/1/edit").should route_to("user_relationship#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_relationship").should route_to("user_relationship#create")
    end

    it "routes to #update" do
      put("/user_relationship/1").should route_to("user_relationship#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_relationship/1").should route_to("user_relationship#destroy", :id => "1")
    end

  end
end
