require 'spec_helper'

describe "hunting_plot_user_access/new" do
  before(:each) do
    assign(:hunting_plot_user_access, stub_model(HuntingPlotUserAccess).as_new_record)
  end

  it "renders new hunting_plot_user_access form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plot_user_accesses_path, "post" do
    end
  end
end
