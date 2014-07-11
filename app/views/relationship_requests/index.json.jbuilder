json.array!(@relationship_requests) do |relationship_request|
  json.extract! relationship_request , :created_by_id, :related_user_id, :status
  json.url relationship_request_url(relationship_request, format: :json)
end
