json.array!(@user_networks) do |user_network|
  json.extract! user_network, :id , :name, :network_type
  json.url user_network_url(user_network, format: :json)
end
