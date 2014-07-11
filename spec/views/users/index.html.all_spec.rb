require 'spec_helper'

describe "user/index" do
  before(:each) do
    assign(:user, [
      stub_model(User),
      stub_model(User)
    ])
  end

  it "renders a list of user" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
