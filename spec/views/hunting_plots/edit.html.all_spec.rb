require 'spec_helper'

describe "hunting_plot/edit" do
  before(:each) do
    @hunting_plot = assign(:hunting_plot, stub_model(HuntingPlot))
  end

  it "renders the edit hunting_plot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plot_path(@hunting_plot), "post" do
    end
  end
end
