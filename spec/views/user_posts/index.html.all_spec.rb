require 'spec_helper'

describe "user_post/index" do
  before(:each) do
    assign(:user_post, [
      stub_model(UserPost),
      stub_model(UserPost)
    ])
  end

  it "renders a list of user_post" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
