require 'spec_helper'

describe "animal_activity_observation/edit" do
  before(:each) do
    @animal_activity_observation = assign(:animal_activity_observation, stub_model(AnimalActivityObservation))
  end

  it "renders the edit animal_activity_observation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", animal_activity_observation_path(@animal_activity_observation), "post" do
    end
  end
end
