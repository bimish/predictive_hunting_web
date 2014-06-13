require 'spec_helper'

describe "user_relationship/show" do
  before(:each) do
    @user_relationship = assign(:user_relationship, stub_model(UserRelationship,
      :owning_user_id => 1,
      :related_user_id => 2,
      :relationship_type => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(//)
  end
end
