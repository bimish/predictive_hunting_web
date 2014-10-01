require 'spec_helper'

describe "HuntingPlotUserAccessRequests" do
  describe "GET /hunting_plot_user_access_request" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get hunting_plot_user_access_requests_path
      response.status.should be(200)
    end
  end
end
