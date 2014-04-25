require 'spec_helper'

describe "user_hunting_plot_accesses/show" do
  before(:each) do
    @user_hunting_plot_access = assign(:user_hunting_plot_access, stub_model(UserHuntingPlotAccess,
      :users => nil,
      :hunting_plots => nil,
      :alias => "Alias",
      :permissions => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Alias/)
    rendered.should match(/1/)
  end
end
