json.array!(@hunting_plot_named_animals) do |hunting_plot_named_animal|
  json.extract! hunting_plot_named_animal, :id, :name, :animal_species_id, :animal_category_id
  json.url hunting_plot_named_animal_url(hunting_plot_named_animal, format: :json)
end
