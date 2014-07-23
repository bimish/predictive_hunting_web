json.array!(@user_network_boundaries) do |user_network_boundary|
  json.extract! user_network_boundary, :id , :user_network_id, :boundary
  json.url user_network_boundary_url(user_network_boundary, format: :json)
end
