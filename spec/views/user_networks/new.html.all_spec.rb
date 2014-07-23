require 'spec_helper'

describe "user_network/new" do
  before(:each) do
    assign(:user_network, stub_model(UserNetwork).as_new_record)
  end

  it "renders new user_network form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_networks_path, "post" do
    end
  end
end
