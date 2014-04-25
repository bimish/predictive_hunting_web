require 'spec_helper'

describe "animal_activity_types/index" do
  before(:each) do
    assign(:animal_activity_types, [
      stub_model(AnimalActivityType,
        :name => "Name"
      ),
      stub_model(AnimalActivityType,
        :name => "Name"
      )
    ])
  end

  it "renders a list of animal_activity_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
