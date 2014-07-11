require 'spec_helper'

describe "animal_activity_observation/index" do
  before(:each) do
    assign(:animal_activity_observation, [
      stub_model(AnimalActivityObservation),
      stub_model(AnimalActivityObservation)
    ])
  end

  it "renders a list of animal_activity_observation" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
