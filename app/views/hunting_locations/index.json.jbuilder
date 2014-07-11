json.array!(@hunting_locations) do |hunting_location|
  json.extract! hunting_location, :id
  json.url hunting_location_url(hunting_location, format: :json)
end
