json.array!(@animal_activity_observations) do |animal_activity_observation|
  json.extract! animal_activity_observation, :id
  json.url animal_activity_observation_url(animal_activity_observation, format: :json)
end
