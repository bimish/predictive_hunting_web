require 'spec_helper'

describe "hunting_plot_user_access_request/new" do
  before(:each) do
    assign(:hunting_plot_user_access_request, stub_model(HuntingPlotUserAccessRequest).as_new_record)
  end

  it "renders new hunting_plot_user_access_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plot_user_access_requests_path, "post" do
    end
  end
end
