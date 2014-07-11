require 'spec_helper'

describe "animal_activity_observation/show" do
  before(:each) do
    @animal_activity_observation = assign(:animal_activity_observation, stub_model(AnimalActivityObservation))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
