require 'spec_helper'

describe "hunting_locations/new" do
  before(:each) do
    assign(:hunting_location, stub_model(HuntingLocation,
      :name => "MyString",
      :coordinates => "",
      :hunting_plot => nil,
      :location_type => 1
    ).as_new_record)
  end

  it "renders new hunting_location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_locations_path, "post" do
      assert_select "input#hunting_location_name[name=?]", "hunting_location[name]"
      assert_select "input#hunting_location_coordinates[name=?]", "hunting_location[coordinates]"
      assert_select "input#hunting_location_hunting_plot[name=?]", "hunting_location[hunting_plot]"
      assert_select "input#hunting_location_location_type[name=?]", "hunting_location[location_type]"
    end
  end
end
