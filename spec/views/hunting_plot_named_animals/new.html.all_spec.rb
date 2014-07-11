require 'spec_helper'

describe "hunting_plot_named_animal/new" do
  before(:each) do
    assign(:hunting_plot_named_animal, stub_model(HuntingPlotNamedAnimal).as_new_record)
  end

  it "renders new hunting_plot_named_animal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hunting_plot_named_animals_path, "post" do
    end
  end
end
