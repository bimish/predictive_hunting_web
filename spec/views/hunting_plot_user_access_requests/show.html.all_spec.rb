require 'spec_helper'

describe "hunting_plot_user_access_request/show" do
  before(:each) do
    @hunting_plot_user_access_request = assign(:hunting_plot_user_access_request, stub_model(HuntingPlotUserAccessRequest))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
