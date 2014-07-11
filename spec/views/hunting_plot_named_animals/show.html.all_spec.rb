require 'spec_helper'

describe "hunting_plot_named_animal/show" do
  before(:each) do
    @hunting_plot_named_animal = assign(:hunting_plot_named_animal, stub_model(HuntingPlotNamedAnimal))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
