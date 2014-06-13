require 'spec_helper'

describe "user_relationship/new" do
  before(:each) do
    assign(:user_relationship, stub_model(UserRelationship).as_new_record)
  end

  it "renders new user_relationship form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_relationships_path, "post" do
    end
  end
end
