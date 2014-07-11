require 'spec_helper'

describe "hunting_location/new" do
  before(:each) do
    assign(:hunting_location, stub_model(HuntingLocation).as_new_record)
  end

  it "renders new hunting_location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_locations_path, "post" do
    end
  end
end
