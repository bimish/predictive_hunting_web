module UserRelationshipsHelper
  include Generated::UserRelationshipsHelper
    def get_owning_user_list_items()
      User.all.map { |u| [u.alias, u.id] }
    end
    def get_related_user_list_items()
      User.all.map { |u| [u.alias, u.id] }
    end
    def get_relationship_type_list_items()
      DataDomains::UserRelationshipType
    end
    def get_relationship_type_description(user_relationship)
      DataDomains::UserRelationshipType.key(user_relationship.relationship_type)
    end
end
