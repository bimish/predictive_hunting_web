require 'spec_helper'

describe "hunting_plot/index" do
  before(:each) do
    assign(:hunting_plot, [
      stub_model(HuntingPlot),
      stub_model(HuntingPlot)
    ])
  end

  it "renders a list of hunting_plot" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
