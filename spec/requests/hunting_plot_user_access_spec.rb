require 'spec_helper'

describe "HuntingPlotUserAccesses" do
  describe "GET /hunting_plot_user_access" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get hunting_plot_user_accesses_path
      response.status.should be(200)
    end
  end
end
