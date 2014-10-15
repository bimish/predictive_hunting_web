require 'spec_helper'

describe "HuntingModeUserStatuses" do
  describe "GET /hunting_mode_user_status" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get hunting_mode_user_statuses_path
      response.status.should be(200)
    end
  end
end
