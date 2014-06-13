require 'spec_helper'

describe "user_post/show" do
  before(:each) do
    @user_post = assign(:user_post, stub_model(UserPost,
      :user => nil,
      :post_content => "Post Content",
      :visibility => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Post Content/)
    rendered.should match(/1/)
  end
end
