require 'spec_helper'

describe "UserNetworkBoundaries" do
  describe "GET /user_network_boundary" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_network_boundaries_path
      response.status.should be(200)
    end
  end
end
