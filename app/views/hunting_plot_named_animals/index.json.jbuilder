json.array!(@hunting_plot_named_animals) do |hunting_plot_named_animal|
  json.extract! hunting_plot_named_animal, :id
  json.url hunting_plot_named_animal_url(hunting_plot_named_animal, format: :json)
end
