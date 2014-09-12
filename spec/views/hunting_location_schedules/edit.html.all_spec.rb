require 'spec_helper'

describe "hunting_location_schedule/edit" do
  before(:each) do
    @hunting_location_schedule = assign(:hunting_location_schedule, stub_model(HuntingLocationSchedule))
  end

  it "renders the edit hunting_location_schedule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_location_schedule_path(@hunting_location_schedule), "post" do
    end
  end
end
