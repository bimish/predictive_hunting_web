json.array!(@hunting_plot_user_access_requests) do |hunting_plot_user_access_request|
  json.extract! hunting_plot_user_access_request, :id, :user_id, :user_invitation_id, :hunting_plot_id, :message, :alias, :initial_permissions_can_administrate, :initial_permissions_can_manage_locations, :initial_permissions_can_manage_members, :initial_permissions_can_manage_named_animals, :initial_permissions_can_manage_schedules, :created_by_user_id, :created_at, :updated_at
  json.url hunting_plot_user_access_request_url(hunting_plot_user_access_request, format: :json)
end
