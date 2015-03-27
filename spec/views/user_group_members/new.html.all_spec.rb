require 'spec_helper'

describe "user_group_member/new" do
  before(:each) do
    assign(:user_group_member, stub_model(UserGroupMember).as_new_record)
  end

  it "renders new user_group_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_group_members_path, "post" do
    end
  end
end
