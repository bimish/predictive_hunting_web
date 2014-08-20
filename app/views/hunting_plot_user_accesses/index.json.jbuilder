json.array!(@hunting_plot_user_accesses) do |hunting_plot_user_access|
  json.extract! hunting_plot_user_access, :id, :user_id, :hunting_plot_id, :alias, :permissions_can_administrate, :permissions_can_manage_locations, :permissions_can_manage_members, :created_at, :updated_at
  json.url hunting_plot_user_access_url(hunting_plot_user_access, format: :json)
end
