require 'spec_helper'

describe "animal_activity_types/edit" do
  before(:each) do
    @animal_activity_type = assign(:animal_activity_type, stub_model(AnimalActivityType,
      :name => "MyString"
    ))
  end

  it "renders the edit animal_activity_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", animal_activity_type_path(@animal_activity_type), "post" do
      assert_select "input#animal_activity_type_name[name=?]", "animal_activity_type[name]"
    end
  end
end
