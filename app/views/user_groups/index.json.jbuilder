json.array!(@user_groups) do |user_group|
  json.extract! user_group, :id, :name, :group_type, :hunting_plot_id, :created_at, :updated_at
  json.url user_group_url(user_group, format: :json)
end
