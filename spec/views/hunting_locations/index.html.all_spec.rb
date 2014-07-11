require 'spec_helper'

describe "hunting_location/index" do
  before(:each) do
    assign(:hunting_location, [
      stub_model(HuntingLocation),
      stub_model(HuntingLocation)
    ])
  end

  it "renders a list of hunting_location" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
