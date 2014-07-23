json.array!(@composite_network_members) do |composite_network_member|
  json.extract! composite_network_member, :id , :composite_network_id, :member_network_id
  json.url composite_network_member_url(composite_network_member, format: :json)
end
