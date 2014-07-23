require 'spec_helper'

describe "user_network_boundary/show" do
  before(:each) do
    @user_network_boundary = assign(:user_network_boundary, stub_model(UserNetworkBoundary))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
