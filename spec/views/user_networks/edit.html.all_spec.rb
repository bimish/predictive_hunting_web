require 'spec_helper'

describe "user_network/edit" do
  before(:each) do
    @user_network = assign(:user_network, stub_model(UserNetwork))
  end

  it "renders the edit user_network form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_network_path(@user_network), "post" do
    end
  end
end
