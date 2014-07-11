require 'spec_helper'

describe "animal_activity_observation/new" do
  before(:each) do
    assign(:animal_activity_observation, stub_model(AnimalActivityObservation).as_new_record)
  end

  it "renders new animal_activity_observation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", animal_activity_observations_path, "post" do
    end
  end
end
