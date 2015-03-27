require 'spec_helper'

describe "user_group/index" do
  before(:each) do
    assign(:user_group, [
      stub_model(UserGroup),
      stub_model(UserGroup)
    ])
  end

  it "renders a list of user_group" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
