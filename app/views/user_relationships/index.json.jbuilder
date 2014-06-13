json.array!(@user_relationships) do |user_relationship|
  json.extract! user_relationship, :id
  json.url user_relationship_url(user_relationship, format: :json)
end
