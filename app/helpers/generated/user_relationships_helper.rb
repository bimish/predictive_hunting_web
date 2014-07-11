module Generated
  module UserRelationshipsHelper
    def get_owning_user_description(user_relationship)
      return user_relationship.owning_user.get_display_name
    end
  end
end
