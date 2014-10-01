require 'spec_helper'

describe "hunting_plot_user_access_request/edit" do
  before(:each) do
    @hunting_plot_user_access_request = assign(:hunting_plot_user_access_request, stub_model(HuntingPlotUserAccessRequest))
  end

  it "renders the edit hunting_plot_user_access_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plot_user_access_request_path(@hunting_plot_user_access_request), "post" do
    end
  end
end
