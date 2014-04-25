require 'spec_helper'

describe "animal_categories/show" do
  before(:each) do
    @animal_category = assign(:animal_category, stub_model(AnimalCategory,
      :animal_species => nil,
      :name => "Name",
      :gender => 1,
      :maturity => 2,
      :trophy_rating => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
