require 'spec_helper'

describe "user_group_member/show" do
  before(:each) do
    @user_group_member = assign(:user_group_member, stub_model(UserGroupMember))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
