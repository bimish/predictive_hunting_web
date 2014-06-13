require 'spec_helper'

describe "user_relationship/edit" do
  before(:each) do
    @user_relationship = assign(:user_relationship, stub_model(UserRelationship))
  end

  it "renders the edit user_relationship form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_relationship_path(@user_relationship), "post" do
    end
  end
end
