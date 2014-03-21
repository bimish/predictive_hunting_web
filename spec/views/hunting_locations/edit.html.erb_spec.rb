require 'spec_helper'

describe "hunting_locations/edit" do
  before(:each) do
    @hunting_location = assign(:hunting_location, stub_model(HuntingLocation,
      :name => "MyString",
      :coordinates => "",
      :hunting_plot => 1,
      :type => 1
    ))
  end

  it "renders the edit hunting_location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_location_path(@hunting_location), "post" do
      assert_select "input#hunting_location_name[name=?]", "hunting_location[name]"
      assert_select "input#hunting_location_coordinates[name=?]", "hunting_location[coordinates]"
      assert_select "input#hunting_location_hunting_plot[name=?]", "hunting_location[hunting_plot]"
      assert_select "input#hunting_location_type[name=?]", "hunting_location[type]"
    end
  end
end
