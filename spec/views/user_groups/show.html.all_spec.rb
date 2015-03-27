require 'spec_helper'

describe "user_group/show" do
  before(:each) do
    @user_group = assign(:user_group, stub_model(UserGroup))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
