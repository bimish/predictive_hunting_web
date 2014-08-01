json.array!(@user_network_categories) do |user_network_category|
  json.extract! user_network_category, :id , :name, :is_composite, :parent_category_id
  json.url user_network_category_url(user_network_category, format: :json)
end
