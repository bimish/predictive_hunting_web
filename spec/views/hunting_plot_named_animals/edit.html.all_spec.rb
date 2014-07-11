require 'spec_helper'

describe "hunting_plot_named_animal/edit" do
  before(:each) do
    @hunting_plot_named_animal = assign(:hunting_plot_named_animal, stub_model(HuntingPlotNamedAnimal))
  end

  it "renders the edit hunting_plot_named_animal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plot_named_animal_path(@hunting_plot_named_animal), "post" do
    end
  end
end
