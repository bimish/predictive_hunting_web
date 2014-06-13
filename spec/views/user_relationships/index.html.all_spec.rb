require 'spec_helper'

describe "user_relationship/index" do
  before(:each) do
    assign(:user_relationship, [
      stub_model(UserRelationship),
      stub_model(UserRelationship)
    ])
  end

  it "renders a list of user_relationship" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
