require 'spec_helper'

describe "user_network_category/new" do
  before(:each) do
    assign(:user_network_category, stub_model(UserNetworkCategory).as_new_record)
  end

  it "renders new user_network_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_network_categories_path, "post" do
    end
  end
end
