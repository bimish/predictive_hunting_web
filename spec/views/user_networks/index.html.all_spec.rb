require 'spec_helper'

describe "user_network/index" do
  before(:each) do
    assign(:user_network, [
      stub_model(UserNetwork),
      stub_model(UserNetwork)
    ])
  end

  it "renders a list of user_network" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
