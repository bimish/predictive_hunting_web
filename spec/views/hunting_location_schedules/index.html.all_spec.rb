require 'spec_helper'

describe "hunting_location_schedule/index" do
  before(:each) do
    assign(:hunting_location_schedule, [
      stub_model(HuntingLocationSchedule),
      stub_model(HuntingLocationSchedule)
    ])
  end

  it "renders a list of hunting_location_schedule" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
