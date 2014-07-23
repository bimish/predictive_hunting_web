require 'spec_helper'

describe "user_network_boundary/edit" do
  before(:each) do
    @user_network_boundary = assign(:user_network_boundary, stub_model(UserNetworkBoundary))
  end

  it "renders the edit user_network_boundary form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_network_boundary_path(@user_network_boundary), "post" do
    end
  end
end
