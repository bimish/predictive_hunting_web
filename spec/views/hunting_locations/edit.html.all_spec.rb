require 'spec_helper'

describe "hunting_location/edit" do
  before(:each) do
    @hunting_location = assign(:hunting_location, stub_model(HuntingLocation))
  end

  it "renders the edit hunting_location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_location_path(@hunting_location), "post" do
    end
  end
end
