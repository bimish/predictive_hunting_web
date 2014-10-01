require "spec_helper"

describe UserInvitationsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_invitation").should route_to("user_invitation#index")
    end

    it "routes to #new" do
      get("/user_invitation/new").should route_to("user_invitation#new")
    end

    it "routes to #show" do
      get("/user_invitation/1").should route_to("user_invitation#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_invitation/1/edit").should route_to("user_invitation#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_invitation").should route_to("user_invitation#create")
    end

    it "routes to #update" do
      put("/user_invitation/1").should route_to("user_invitation#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_invitation/1").should route_to("user_invitation#destroy", :id => "1")
    end

  end
end
