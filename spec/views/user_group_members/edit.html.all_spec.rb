require 'spec_helper'

describe "user_group_member/edit" do
  before(:each) do
    @user_group_member = assign(:user_group_member, stub_model(UserGroupMember))
  end

  it "renders the edit user_group_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_group_member_path(@user_group_member), "post" do
    end
  end
end
