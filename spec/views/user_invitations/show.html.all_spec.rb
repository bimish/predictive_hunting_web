require 'spec_helper'

describe "user_invitation/show" do
  before(:each) do
    @user_invitation = assign(:user_invitation, stub_model(UserInvitation))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
