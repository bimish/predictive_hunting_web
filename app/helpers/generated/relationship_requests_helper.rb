module Generated
  module RelationshipRequestsHelper
    def get_related_user_description(relationship_request)
      return relationship_request.related_user.get_display_name
    end
  end
end
