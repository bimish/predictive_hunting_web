json.(hunting_location, :id, :hunting_plot_id, :name, :location_type, :created_at, :updated_at)
json.coordinates do |json|
  json.lat hunting_location.coordinates.y()
  json.lng hunting_location.coordinates.x()
end
