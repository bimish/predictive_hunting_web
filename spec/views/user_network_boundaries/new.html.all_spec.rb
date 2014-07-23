require 'spec_helper'

describe "user_network_boundary/new" do
  before(:each) do
    assign(:user_network_boundary, stub_model(UserNetworkBoundary).as_new_record)
  end

  it "renders new user_network_boundary form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_network_boundaries_path, "post" do
    end
  end
end
