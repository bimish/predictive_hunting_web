require 'spec_helper'

describe "user_hunting_plot_accesses/index" do
  before(:each) do
    assign(:user_hunting_plot_accesses, [
      stub_model(UserHuntingPlotAccess,
        :users => nil,
        :hunting_plots => nil,
        :alias => "Alias",
        :permissions => 1
      ),
      stub_model(UserHuntingPlotAccess,
        :users => nil,
        :hunting_plots => nil,
        :alias => "Alias",
        :permissions => 1
      )
    ])
  end

  it "renders a list of user_hunting_plot_accesses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Alias".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
