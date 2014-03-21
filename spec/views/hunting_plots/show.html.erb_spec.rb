require 'spec_helper'

describe "hunting_plots/show" do
  before(:each) do
    @hunting_plot = assign(:hunting_plot, stub_model(HuntingPlot,
      :name => "Name",
      :location_coordinates => "Location Coordinates",
      :boundary => "Boundary"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Location Coordinates/)
    rendered.should match(/Boundary/)
  end
end
