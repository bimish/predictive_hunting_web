require 'spec_helper'

describe "user_group/new" do
  before(:each) do
    assign(:user_group, stub_model(UserGroup).as_new_record)
  end

  it "renders new user_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_groups_path, "post" do
    end
  end
end
