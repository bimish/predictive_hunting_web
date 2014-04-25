json.array!(@animal_species) do |animal_species|
  json.extract! animal_species, :id, :common_name, :species
  json.url animal_species_url(animal_species, format: :json)
end
