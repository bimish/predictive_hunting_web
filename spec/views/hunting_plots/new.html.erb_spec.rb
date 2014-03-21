require 'spec_helper'

describe "hunting_plots/new" do
  before(:each) do
    assign(:hunting_plot, stub_model(HuntingPlot,
      :name => "MyString",
      :location_coordinates => "MyString",
      :boundary => "MyString"
    ).as_new_record)
  end

  it "renders new hunting_plot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plots_path, "post" do
      assert_select "input#hunting_plot_name[name=?]", "hunting_plot[name]"
      assert_select "input#hunting_plot_location_coordinates[name=?]", "hunting_plot[location_coordinates]"
      assert_select "input#hunting_plot_boundary[name=?]", "hunting_plot[boundary]"
    end
  end
end
