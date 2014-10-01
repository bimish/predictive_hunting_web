require 'spec_helper'

describe "user_invitation/edit" do
  before(:each) do
    @user_invitation = assign(:user_invitation, stub_model(UserInvitation))
  end

  it "renders the edit user_invitation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_invitation_path(@user_invitation), "post" do
    end
  end
end
