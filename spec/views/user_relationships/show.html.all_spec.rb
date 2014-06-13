require 'spec_helper'

describe "user_relationship/show" do
  before(:each) do
    @user_relationship = assign(:user_relationship, stub_model(UserRelationship))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
