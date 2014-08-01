module Generated
  module UserNetworkCategoriesHelper
    def get_parent_category_description(user_network_category)
      return user_network_category.parent_category.get_display_name
    end
  end
end
