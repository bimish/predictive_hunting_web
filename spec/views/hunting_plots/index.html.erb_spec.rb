require 'spec_helper'

describe "hunting_plots/index" do
  before(:each) do
    assign(:hunting_plots, [
      stub_model(HuntingPlot,
        :name => "Name",
        :location_coordinates => "Location Coordinates",
        :boundary => "Boundary"
      ),
      stub_model(HuntingPlot,
        :name => "Name",
        :location_coordinates => "Location Coordinates",
        :boundary => "Boundary"
      )
    ])
  end

  it "renders a list of hunting_plots" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Location Coordinates".to_s, :count => 2
    assert_select "tr>td", :text => "Boundary".to_s, :count => 2
  end
end
