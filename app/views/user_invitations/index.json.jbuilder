json.array!(@user_invitations) do |user_invitation|
  json.extract! user_invitation, :id, :email, :created_by_id, :message, :status, :created_at, :updated_at
  json.url user_invitation_url(user_invitation, format: :json)
end
