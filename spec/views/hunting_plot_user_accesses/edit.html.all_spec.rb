require 'spec_helper'

describe "hunting_plot_user_access/edit" do
  before(:each) do
    @hunting_plot_user_access = assign(:hunting_plot_user_access, stub_model(HuntingPlotUserAccess))
  end

  it "renders the edit hunting_plot_user_access form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plot_user_access_path(@hunting_plot_user_access), "post" do
    end
  end
end
