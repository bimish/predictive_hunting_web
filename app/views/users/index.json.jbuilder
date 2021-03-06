json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :alias, :email, :password_digest, :authentication_method, :admin, :created_at, :updated_at
  json.url user_url(user, format: :json)
end
