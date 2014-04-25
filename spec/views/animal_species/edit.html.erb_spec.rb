require 'spec_helper'

describe "animal_species/edit" do
  before(:each) do
    @animal_species = assign(:animal_species, stub_model(AnimalSpecies,
      :common_name => "MyString",
      :species => "MyString"
    ))
  end

  it "renders the edit animal_species form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", animal_species_path(@animal_species), "post" do
      assert_select "input#animal_species_common_name[name=?]", "animal_species[common_name]"
      assert_select "input#animal_species_species[name=?]", "animal_species[species]"
    end
  end
end
