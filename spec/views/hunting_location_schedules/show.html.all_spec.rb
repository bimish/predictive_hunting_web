require 'spec_helper'

describe "hunting_location_schedule/show" do
  before(:each) do
    @hunting_location_schedule = assign(:hunting_location_schedule, stub_model(HuntingLocationSchedule))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
