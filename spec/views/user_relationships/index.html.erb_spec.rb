require 'spec_helper'

describe "user_relationship/index" do
  before(:each) do
    assign(:user_relationship, [
      stub_model(UserRelationship,
        :owning_user_id => 1,
        :related_user_id => 2,
        :relationship_type => ""
      ),
      stub_model(UserRelationship,
        :owning_user_id => 1,
        :related_user_id => 2,
        :relationship_type => ""
      )
    ])
  end

  it "renders a list of user_relationship" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
