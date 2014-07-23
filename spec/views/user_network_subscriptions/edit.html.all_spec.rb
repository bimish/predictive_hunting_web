require 'spec_helper'

describe "user_network_subscription/edit" do
  before(:each) do
    @user_network_subscription = assign(:user_network_subscription, stub_model(UserNetworkSubscription))
  end

  it "renders the edit user_network_subscription form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_network_subscription_path(@user_network_subscription), "post" do
    end
  end
end
