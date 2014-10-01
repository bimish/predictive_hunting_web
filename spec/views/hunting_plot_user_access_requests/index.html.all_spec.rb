require 'spec_helper'

describe "hunting_plot_user_access_request/index" do
  before(:each) do
    assign(:hunting_plot_user_access_request, [
      stub_model(HuntingPlotUserAccessRequest),
      stub_model(HuntingPlotUserAccessRequest)
    ])
  end

  it "renders a list of hunting_plot_user_access_request" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
