require 'spec_helper'

describe "user_post/edit" do
  before(:each) do
    @user_post = assign(:user_post, stub_model(UserPost))
  end

  it "renders the edit user_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_post_path(@user_post), "post" do
    end
  end
end
