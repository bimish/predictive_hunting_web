require "spec_helper"

describe UserPostsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_post").should route_to("user_post#index")
    end

    it "routes to #new" do
      get("/user_post/new").should route_to("user_post#new")
    end

    it "routes to #show" do
      get("/user_post/1").should route_to("user_post#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_post/1/edit").should route_to("user_post#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_post").should route_to("user_post#create")
    end

    it "routes to #update" do
      put("/user_post/1").should route_to("user_post#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_post/1").should route_to("user_post#destroy", :id => "1")
    end

  end
end
