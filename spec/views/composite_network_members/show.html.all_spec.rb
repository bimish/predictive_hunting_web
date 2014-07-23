require 'spec_helper'

describe "composite_network_member/show" do
  before(:each) do
    @composite_network_member = assign(:composite_network_member, stub_model(CompositeNetworkMember))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
