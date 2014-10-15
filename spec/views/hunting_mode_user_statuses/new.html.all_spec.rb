require 'spec_helper'

describe "hunting_mode_user_status/new" do
  before(:each) do
    assign(:hunting_mode_user_status, stub_model(HuntingModeUserStatus).as_new_record)
  end

  it "renders new hunting_mode_user_status form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_mode_user_statuses_path, "post" do
    end
  end
end
