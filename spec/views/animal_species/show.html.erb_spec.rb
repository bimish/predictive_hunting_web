require 'spec_helper'

describe "animal_species/show" do
  before(:each) do
    @animal_species = assign(:animal_species, stub_model(AnimalSpecies,
      :common_name => "Common Name",
      :species => "Species"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Common Name/)
    rendered.should match(/Species/)
  end
end
