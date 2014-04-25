require 'spec_helper'

describe "animal_activity_observations/index" do
  before(:each) do
    assign(:animal_activity_observations, [
      stub_model(AnimalActivityObservation,
        :hunting_location => nil,
        :animal_category => nil,
        :animal_count => 1,
        :animal_activity_type => nil,
        :hunting_plot_named_animal => nil
      ),
      stub_model(AnimalActivityObservation,
        :hunting_location => nil,
        :animal_category => nil,
        :animal_count => 1,
        :animal_activity_type => nil,
        :hunting_plot_named_animal => nil
      )
    ])
  end

  it "renders a list of animal_activity_observations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
