require 'spec_helper'

describe "hunting_locations/show" do
  before(:each) do
    @hunting_location = assign(:hunting_location, stub_model(HuntingLocation,
      :name => "Name",
      :coordinates => "",
      :hunting_plot => nil,
      :location_type => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/1/)
  end
end
