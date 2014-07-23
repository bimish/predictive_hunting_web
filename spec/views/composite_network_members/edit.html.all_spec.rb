require 'spec_helper'

describe "composite_network_member/edit" do
  before(:each) do
    @composite_network_member = assign(:composite_network_member, stub_model(CompositeNetworkMember))
  end

  it "renders the edit composite_network_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", composite_network_member_path(@composite_network_member), "post" do
    end
  end
end
