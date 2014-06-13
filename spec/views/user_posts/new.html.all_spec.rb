require 'spec_helper'

describe "user_post/new" do
  before(:each) do
    assign(:user_post, stub_model(UserPost).as_new_record)
  end

  it "renders new user_post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_posts_path, "post" do
    end
  end
end
