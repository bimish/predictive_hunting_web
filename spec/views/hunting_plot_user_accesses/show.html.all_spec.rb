require 'spec_helper'

describe "hunting_plot_user_access/show" do
  before(:each) do
    @hunting_plot_user_access = assign(:hunting_plot_user_access, stub_model(HuntingPlotUserAccess))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
