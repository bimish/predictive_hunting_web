require 'spec_helper'

describe "user_network_subscription/index" do
  before(:each) do
    assign(:user_network_subscription, [
      stub_model(UserNetworkSubscription),
      stub_model(UserNetworkSubscription)
    ])
  end

  it "renders a list of user_network_subscription" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
