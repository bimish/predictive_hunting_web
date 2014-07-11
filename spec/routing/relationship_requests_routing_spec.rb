require "spec_helper"

describe RelationshipRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/relationship_request").should route_to("relationship_request#index")
    end

    it "routes to #new" do
      get("/relationship_request/new").should route_to("relationship_request#new")
    end

    it "routes to #show" do
      get("/relationship_request/1").should route_to("relationship_request#show", :id => "1")
    end

    it "routes to #edit" do
      get("/relationship_request/1/edit").should route_to("relationship_request#edit", :id => "1")
    end

    it "routes to #create" do
      post("/relationship_request").should route_to("relationship_request#create")
    end

    it "routes to #update" do
      put("/relationship_request/1").should route_to("relationship_request#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/relationship_request/1").should route_to("relationship_request#destroy", :id => "1")
    end

  end
end
