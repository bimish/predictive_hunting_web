require 'spec_helper'

describe "hunting_plot_named_animal/index" do
  before(:each) do
    assign(:hunting_plot_named_animal, [
      stub_model(HuntingPlotNamedAnimal),
      stub_model(HuntingPlotNamedAnimal)
    ])
  end

  it "renders a list of hunting_plot_named_animal" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
