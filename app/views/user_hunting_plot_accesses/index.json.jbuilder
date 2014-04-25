json.array!(@user_hunting_plot_accesses) do |user_hunting_plot_access|
  json.extract! user_hunting_plot_access, :id, :users_id, :hunting_plots_id, :alias, :permissions
  json.url user_hunting_plot_access_url(user_hunting_plot_access, format: :json)
end
