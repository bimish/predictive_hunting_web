require 'spec_helper'

describe "user_relationship/new" do
  before(:each) do
    assign(:user_relationship, stub_model(UserRelationship,
      :owning_user_id => 1,
      :related_user_id => 1,
      :relationship_type => ""
    ).as_new_record)
  end

  it "renders new user_relationship form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_relationships_path, "post" do
      assert_select "input#user_relationship_owning_user_id[name=?]", "user_relationship[owning_user_id]"
      assert_select "input#user_relationship_related_user_id[name=?]", "user_relationship[related_user_id]"
      assert_select "input#user_relationship_relationship_type[name=?]", "user_relationship[relationship_type]"
    end
  end
end
