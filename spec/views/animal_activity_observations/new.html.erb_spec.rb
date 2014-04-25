require 'spec_helper'

describe "animal_activity_observations/new" do
  before(:each) do
    assign(:animal_activity_observation, stub_model(AnimalActivityObservation,
      :hunting_location => nil,
      :animal_category => nil,
      :animal_count => 1,
      :animal_activity_type => nil,
      :hunting_plot_named_animal => nil
    ).as_new_record)
  end

  it "renders new animal_activity_observation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", animal_activity_observations_path, "post" do
      assert_select "input#animal_activity_observation_hunting_location[name=?]", "animal_activity_observation[hunting_location]"
      assert_select "input#animal_activity_observation_animal_category[name=?]", "animal_activity_observation[animal_category]"
      assert_select "input#animal_activity_observation_animal_count[name=?]", "animal_activity_observation[animal_count]"
      assert_select "input#animal_activity_observation_animal_activity_type[name=?]", "animal_activity_observation[animal_activity_type]"
      assert_select "input#animal_activity_observation_hunting_plot_named_animal[name=?]", "animal_activity_observation[hunting_plot_named_animal]"
    end
  end
end
