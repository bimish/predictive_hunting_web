json.array!(@user_networks) do |user_network|
  json.extract! user_network, :id , :name, :category_id, :parent_network_id
  json.url user_network_url(user_network, format: :json)
end
