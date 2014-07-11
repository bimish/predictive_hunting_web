require 'spec_helper'

describe "AnimalActivityObservations" do
  describe "GET /animal_activity_observation" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get animal_activity_observations_path
      response.status.should be(200)
    end
  end
end
