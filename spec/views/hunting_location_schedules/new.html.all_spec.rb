require 'spec_helper'

describe "hunting_location_schedule/new" do
  before(:each) do
    assign(:hunting_location_schedule, stub_model(HuntingLocationSchedule).as_new_record)
  end

  it "renders new hunting_location_schedule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_location_schedules_path, "post" do
    end
  end
end
