require 'spec_helper'

describe "user_network/show" do
  before(:each) do
    @user_network = assign(:user_network, stub_model(UserNetwork))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
