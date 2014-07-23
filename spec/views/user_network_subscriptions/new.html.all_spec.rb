require 'spec_helper'

describe "user_network_subscription/new" do
  before(:each) do
    assign(:user_network_subscription, stub_model(UserNetworkSubscription).as_new_record)
  end

  it "renders new user_network_subscription form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_network_subscriptions_path, "post" do
    end
  end
end
