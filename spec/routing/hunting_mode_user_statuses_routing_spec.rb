require "spec_helper"

describe HuntingModeUserStatusesController do
  describe "routing" do

    it "routes to #index" do
      get("/hunting_mode_user_status").should route_to("hunting_mode_user_status#index")
    end

    it "routes to #new" do
      get("/hunting_mode_user_status/new").should route_to("hunting_mode_user_status#new")
    end

    it "routes to #show" do
      get("/hunting_mode_user_status/1").should route_to("hunting_mode_user_status#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hunting_mode_user_status/1/edit").should route_to("hunting_mode_user_status#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hunting_mode_user_status").should route_to("hunting_mode_user_status#create")
    end

    it "routes to #update" do
      put("/hunting_mode_user_status/1").should route_to("hunting_mode_user_status#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hunting_mode_user_status/1").should route_to("hunting_mode_user_status#destroy", :id => "1")
    end

  end
end
