require 'spec_helper'

describe "hunting_mode_user_status/index" do
  before(:each) do
    assign(:hunting_mode_user_status, [
      stub_model(HuntingModeUserStatus),
      stub_model(HuntingModeUserStatus)
    ])
  end

  it "renders a list of hunting_mode_user_status" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
