json.array!(@animal_activity_observations) do |animal_activity_observation|
  json.extract! animal_activity_observation, :id, :hunting_location_id, :animal_category_id, :animal_count, :animal_activity_type_id, :hunting_plot_named_animal_id, :observation_date_time
  json.url animal_activity_observation_url(animal_activity_observation, format: :json)
end
