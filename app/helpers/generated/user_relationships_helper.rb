module Generated
  module UserRelationshipsHelper
    def get_owning_user_list_items()

    end
    def get_owning_user_description(user_relationship)
      return user_relationship.owning_user.get_display_name
    end
    def get_related_user_list_items()

    end
    def get_related_user_description(user_relationship)
      return user_relationship.related_user.get_display_name
    end
    def get_relationship_type_list_items()

    end
    def get_relationship_type_description(user_relationship)
      raise NotImplementedError
    end
  end
end
