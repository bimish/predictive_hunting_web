require 'spec_helper'

describe "user_invitation/index" do
  before(:each) do
    assign(:user_invitation, [
      stub_model(UserInvitation),
      stub_model(UserInvitation)
    ])
  end

  it "renders a list of user_invitation" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
