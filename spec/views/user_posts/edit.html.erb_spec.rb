require 'spec_helper'

describe "user_post/edit" do
  before(:each) do
    @user_post = assign(:user_post, stub_model(UserPost,
      :user => nil,
      :post_content => "MyString",
      :visibility => 1
    ))
  end

  it "renders the edit user_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_post_path(@user_post), "post" do
      assert_select "input#user_post_user[name=?]", "user_post[user]"
      assert_select "input#user_post_post_content[name=?]", "user_post[post_content]"
      assert_select "input#user_post_visibility[name=?]", "user_post[visibility]"
    end
  end
end
