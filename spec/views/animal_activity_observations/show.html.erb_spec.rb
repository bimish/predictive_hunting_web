require 'spec_helper'

describe "animal_activity_observations/show" do
  before(:each) do
    @animal_activity_observation = assign(:animal_activity_observation, stub_model(AnimalActivityObservation,
      :hunting_location => nil,
      :animal_category => nil,
      :animal_count => 1,
      :animal_activity_type => nil,
      :hunting_plot_named_animal => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/1/)
    rendered.should match(//)
    rendered.should match(//)
  end
end
