require 'spec_helper'

describe "hunting_mode_user_status/show" do
  before(:each) do
    @hunting_mode_user_status = assign(:hunting_mode_user_status, stub_model(HuntingModeUserStatus))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
