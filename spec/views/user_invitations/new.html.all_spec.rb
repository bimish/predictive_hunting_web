require 'spec_helper'

describe "user_invitation/new" do
  before(:each) do
    assign(:user_invitation, stub_model(UserInvitation).as_new_record)
  end

  it "renders new user_invitation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_invitations_path, "post" do
    end
  end
end
