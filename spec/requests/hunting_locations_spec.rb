require 'spec_helper'

describe "HuntingLocations" do
  describe "GET /hunting_locations" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get hunting_locations_path
      response.status.should be(200)
    end
  end
end
