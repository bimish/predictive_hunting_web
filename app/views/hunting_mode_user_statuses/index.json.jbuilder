json.array!(@hunting_mode_user_statuses) do |hunting_mode_user_status|
  json.extract! hunting_mode_user_status, :id, :user_id, :hunting_plot_id, :status_type, :status_text, :created_at, :updated_at
  json.url hunting_mode_user_status_url(hunting_mode_user_status, format: :json)
end
