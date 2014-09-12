require 'spec_helper'

describe "hunting_plot/new" do
  before(:each) do
    assign(:hunting_plot, stub_model(HuntingPlot).as_new_record)
  end

  it "renders new hunting_plot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plots_path, "post" do
    end
  end
end
