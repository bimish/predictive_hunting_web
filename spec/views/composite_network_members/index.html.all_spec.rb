require 'spec_helper'

describe "composite_network_member/index" do
  before(:each) do
    assign(:composite_network_member, [
      stub_model(CompositeNetworkMember),
      stub_model(CompositeNetworkMember)
    ])
  end

  it "renders a list of composite_network_member" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
