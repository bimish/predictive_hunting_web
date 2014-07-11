require 'spec_helper'

describe "HuntingPlotNamedAnimals" do
  describe "GET /hunting_plot_named_animal" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get hunting_plot_named_animals_path
      response.status.should be(200)
    end
  end
end
