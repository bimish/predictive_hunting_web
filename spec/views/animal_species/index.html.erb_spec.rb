require 'spec_helper'

describe "animal_species/index" do
  before(:each) do
    assign(:animal_species, [
      stub_model(AnimalSpecies,
        :common_name => "Common Name",
        :species => "Species"
      ),
      stub_model(AnimalSpecies,
        :common_name => "Common Name",
        :species => "Species"
      )
    ])
  end

  it "renders a list of animal_species" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Common Name".to_s, :count => 2
    assert_select "tr>td", :text => "Species".to_s, :count => 2
  end
end
