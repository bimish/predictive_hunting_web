require 'spec_helper'

describe "HuntingLocationSchedules" do
  describe "GET /hunting_location_schedule" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get hunting_location_schedules_path
      response.status.should be(200)
    end
  end
end
