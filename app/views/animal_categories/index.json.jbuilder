json.array!(@animal_categories) do |animal_category|
  json.extract! animal_category, :id, :animal_species_id, :name, :gender, :maturity, :trophy_rating
  json.url animal_category_url(animal_category, format: :json)
end
