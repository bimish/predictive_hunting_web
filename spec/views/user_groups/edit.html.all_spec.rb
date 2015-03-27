require 'spec_helper'

describe "user_group/edit" do
  before(:each) do
    @user_group = assign(:user_group, stub_model(UserGroup))
  end

  it "renders the edit user_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_group_path(@user_group), "post" do
    end
  end
end
