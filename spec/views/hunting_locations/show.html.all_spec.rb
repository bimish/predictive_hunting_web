require 'spec_helper'

describe "hunting_location/show" do
  before(:each) do
    @hunting_location = assign(:hunting_location, stub_model(HuntingLocation))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
