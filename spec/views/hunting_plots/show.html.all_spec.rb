require 'spec_helper'

describe "hunting_plot/show" do
  before(:each) do
    @hunting_plot = assign(:hunting_plot, stub_model(HuntingPlot))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
