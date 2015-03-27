json.array!(@user_group_members) do |user_group_member|
  json.extract! user_group_member, :id, :user_group_id, :user_id
  json.url user_group_member_url(user_group_member, format: :json)
end
