require 'spec_helper'

describe "hunting_plots/edit" do
  before(:each) do
    @hunting_plot = assign(:hunting_plot, stub_model(HuntingPlot,
      :name => "MyString",
      :location_coordinates => "MyString",
      :boundary => "MyString"
    ))
  end

  it "renders the edit hunting_plot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plot_path(@hunting_plot), "post" do
      assert_select "input#hunting_plot_name[name=?]", "hunting_plot[name]"
      assert_select "input#hunting_plot_location_coordinates[name=?]", "hunting_plot[location_coordinates]"
      assert_select "input#hunting_plot_boundary[name=?]", "hunting_plot[boundary]"
    end
  end
end
