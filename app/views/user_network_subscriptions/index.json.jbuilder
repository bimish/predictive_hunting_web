json.array!(@user_network_subscriptions) do |user_network_subscription|
  json.extract! user_network_subscription, :id , :user_id, :user_network_id
  json.url user_network_subscription_url(user_network_subscription, format: :json)
end
