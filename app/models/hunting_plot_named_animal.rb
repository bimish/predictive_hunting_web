class HuntingPlotNamedAnimal < ActiveRecord::Base
  belongs_to :animal_species
  belongs_to :animal_category
end
