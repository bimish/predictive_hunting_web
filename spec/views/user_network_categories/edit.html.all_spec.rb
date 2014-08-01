require 'spec_helper'

describe "user_network_category/edit" do
  before(:each) do
    @user_network_category = assign(:user_network_category, stub_model(UserNetworkCategory))
  end

  it "renders the edit user_network_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_network_category_path(@user_network_category), "post" do
    end
  end
end
