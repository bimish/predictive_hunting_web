require 'spec_helper'

describe "CompositeNetworkMembers" do
  describe "GET /composite_network_member" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get composite_network_members_path
      response.status.should be(200)
    end
  end
end
