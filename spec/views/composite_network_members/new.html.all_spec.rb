require 'spec_helper'

describe "composite_network_member/new" do
  before(:each) do
    assign(:composite_network_member, stub_model(CompositeNetworkMember).as_new_record)
  end

  it "renders new composite_network_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", composite_network_members_path, "post" do
    end
  end
end
