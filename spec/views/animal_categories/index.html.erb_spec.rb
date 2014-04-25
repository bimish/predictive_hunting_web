require 'spec_helper'

describe "animal_categories/index" do
  before(:each) do
    assign(:animal_categories, [
      stub_model(AnimalCategory,
        :animal_species => nil,
        :name => "Name",
        :gender => 1,
        :maturity => 2,
        :trophy_rating => 3
      ),
      stub_model(AnimalCategory,
        :animal_species => nil,
        :name => "Name",
        :gender => 1,
        :maturity => 2,
        :trophy_rating => 3
      )
    ])
  end

  it "renders a list of animal_categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
