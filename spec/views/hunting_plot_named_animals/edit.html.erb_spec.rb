require 'spec_helper'

describe "hunting_plot_named_animals/edit" do
  before(:each) do
    @hunting_plot_named_animal = assign(:hunting_plot_named_animal, stub_model(HuntingPlotNamedAnimal,
      :name => "MyString",
      :animal_species => nil,
      :animal_category => nil
    ))
  end

  it "renders the edit hunting_plot_named_animal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plot_named_animal_path(@hunting_plot_named_animal), "post" do
      assert_select "input#hunting_plot_named_animal_name[name=?]", "hunting_plot_named_animal[name]"
      assert_select "input#hunting_plot_named_animal_animal_species[name=?]", "hunting_plot_named_animal[animal_species]"
      assert_select "input#hunting_plot_named_animal_animal_category[name=?]", "hunting_plot_named_animal[animal_category]"
    end
  end
end
