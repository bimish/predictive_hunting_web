require 'spec_helper'

describe "hunting_plot_user_access/index" do
  before(:each) do
    assign(:hunting_plot_user_access, [
      stub_model(HuntingPlotUserAccess),
      stub_model(HuntingPlotUserAccess)
    ])
  end

  it "renders a list of hunting_plot_user_access" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
