module Generated
  module UserNetworksHelper
    def get_category_description(user_network)
      return user_network.category.get_display_name
    end
    def get_parent_network_description(user_network)
      return user_network.parent_network.get_display_name
    end
  end
end
