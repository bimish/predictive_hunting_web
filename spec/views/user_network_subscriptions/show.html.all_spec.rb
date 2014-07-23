require 'spec_helper'

describe "user_network_subscription/show" do
  before(:each) do
    @user_network_subscription = assign(:user_network_subscription, stub_model(UserNetworkSubscription))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
