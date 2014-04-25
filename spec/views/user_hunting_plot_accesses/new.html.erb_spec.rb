require 'spec_helper'

describe "user_hunting_plot_accesses/new" do
  before(:each) do
    assign(:user_hunting_plot_access, stub_model(UserHuntingPlotAccess,
      :users => nil,
      :hunting_plots => nil,
      :alias => "MyString",
      :permissions => 1
    ).as_new_record)
  end

  it "renders new user_hunting_plot_access form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_hunting_plot_accesses_path, "post" do
      assert_select "input#user_hunting_plot_access_users[name=?]", "user_hunting_plot_access[users]"
      assert_select "input#user_hunting_plot_access_hunting_plots[name=?]", "user_hunting_plot_access[hunting_plots]"
      assert_select "input#user_hunting_plot_access_alias[name=?]", "user_hunting_plot_access[alias]"
      assert_select "input#user_hunting_plot_access_permissions[name=?]", "user_hunting_plot_access[permissions]"
    end
  end
end
