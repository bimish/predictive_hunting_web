module Generated
  module UserNetworkSubscriptionsHelper
    def get_user_description(user_network_subscription)
      return user_network_subscription.user.get_display_name
    end
    def get_network_description(user_network_subscription)
      return user_network_subscription.network.get_display_name
    end
  end
end
