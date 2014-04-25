require 'spec_helper'

describe "animal_activity_types/new" do
  before(:each) do
    assign(:animal_activity_type, stub_model(AnimalActivityType,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new animal_activity_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", animal_activity_types_path, "post" do
      assert_select "input#animal_activity_type_name[name=?]", "animal_activity_type[name]"
    end
  end
end
