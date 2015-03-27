require 'spec_helper'

describe "user_group_member/index" do
  before(:each) do
    assign(:user_group_member, [
      stub_model(UserGroupMember),
      stub_model(UserGroupMember)
    ])
  end

  it "renders a list of user_group_member" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
