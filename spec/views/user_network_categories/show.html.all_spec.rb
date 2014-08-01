require 'spec_helper'

describe "user_network_category/show" do
  before(:each) do
    @user_network_category = assign(:user_network_category, stub_model(UserNetworkCategory))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
