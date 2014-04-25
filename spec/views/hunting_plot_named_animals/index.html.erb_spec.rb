require 'spec_helper'

describe "hunting_plot_named_animals/index" do
  before(:each) do
    assign(:hunting_plot_named_animals, [
      stub_model(HuntingPlotNamedAnimal,
        :name => "Name",
        :animal_species => nil,
        :animal_category => nil
      ),
      stub_model(HuntingPlotNamedAnimal,
        :name => "Name",
        :animal_species => nil,
        :animal_category => nil
      )
    ])
  end

  it "renders a list of hunting_plot_named_animals" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
