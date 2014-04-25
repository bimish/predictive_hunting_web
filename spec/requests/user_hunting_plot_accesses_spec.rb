require 'spec_helper'

describe "UserHuntingPlotAccesses" do
  describe "GET /user_hunting_plot_accesses" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_hunting_plot_accesses_path
      response.status.should be(200)
    end
  end
end
