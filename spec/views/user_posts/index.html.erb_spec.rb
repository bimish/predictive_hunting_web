require 'spec_helper'

describe "user_post/index" do
  before(:each) do
    assign(:user_post, [
      stub_model(UserPost,
        :user => nil,
        :post_content => "Post Content",
        :visibility => 1
      ),
      stub_model(UserPost,
        :user => nil,
        :post_content => "Post Content",
        :visibility => 1
      )
    ])
  end

  it "renders a list of user_post" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Post Content".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
