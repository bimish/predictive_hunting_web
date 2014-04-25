require 'spec_helper'

describe "AnimalSpecies" do
  describe "GET /animal_species" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get animal_species_index_path
      response.status.should be(200)
    end
  end
end
