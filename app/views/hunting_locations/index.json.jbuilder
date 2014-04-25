json.array!(@hunting_locations) do |hunting_location|
  json.extract! hunting_location, :id, :name, :coordinates, :hunting_plot_id, :location_type
  json.url hunting_location_url(hunting_location, format: :json)
end
