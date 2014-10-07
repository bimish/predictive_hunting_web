json.array!(@user_posts) do |user_post|
  json.extract! user_post, :id, :created_by_id, :post_content, :visibility, :created_at, :updated_at
  json.url user_post_url(user_post, format: :json)
end
