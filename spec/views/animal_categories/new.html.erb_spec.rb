require 'spec_helper'

describe "animal_categories/new" do
  before(:each) do
    assign(:animal_category, stub_model(AnimalCategory,
      :animal_species => nil,
      :name => "MyString",
      :gender => 1,
      :maturity => 1,
      :trophy_rating => 1
    ).as_new_record)
  end

  it "renders new animal_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", animal_categories_path, "post" do
      assert_select "input#animal_category_animal_species[name=?]", "animal_category[animal_species]"
      assert_select "input#animal_category_name[name=?]", "animal_category[name]"
      assert_select "input#animal_category_gender[name=?]", "animal_category[gender]"
      assert_select "input#animal_category_maturity[name=?]", "animal_category[maturity]"
      assert_select "input#animal_category_trophy_rating[name=?]", "animal_category[trophy_rating]"
    end
  end
end
