require 'spec_helper'

describe "hunting_mode_user_status/edit" do
  before(:each) do
    @hunting_mode_user_status = assign(:hunting_mode_user_status, stub_model(HuntingModeUserStatus))
  end

  it "renders the edit hunting_mode_user_status form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_mode_user_status_path(@hunting_mode_user_status), "post" do
    end
  end
end
