json.array!(@hunting_plots) do |hunting_plot|
  json.extract! hunting_plot, :id, :name, :location_address, :location_coordinates, :created_at, :updated_at, :boundary
  json.url hunting_plot_url(hunting_plot, format: :json)
end
