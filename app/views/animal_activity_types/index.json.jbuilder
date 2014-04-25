json.array!(@animal_activity_types) do |animal_activity_type|
  json.extract! animal_activity_type, :id, :name
  json.url animal_activity_type_url(animal_activity_type, format: :json)
end
