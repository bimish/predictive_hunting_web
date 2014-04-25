require 'spec_helper'

describe "hunting_locations/index" do
  before(:each) do
    assign(:hunting_locations, [
      stub_model(HuntingLocation,
        :name => "Name",
        :coordinates => "",
        :hunting_plot => nil,
        :location_type => 1
      ),
      stub_model(HuntingLocation,
        :name => "Name",
        :coordinates => "",
        :hunting_plot => nil,
        :location_type => 1
      )
    ])
  end

  it "renders a list of hunting_locations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
