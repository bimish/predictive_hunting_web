require 'spec_helper'

describe "user_network_category/index" do
  before(:each) do
    assign(:user_network_category, [
      stub_model(UserNetworkCategory),
      stub_model(UserNetworkCategory)
    ])
  end

  it "renders a list of user_network_category" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
