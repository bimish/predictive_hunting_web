module EnumsHelper
  module HuntingLocationEnums
    def self.location_types
      @@location_types_map ||= HuntingLocation.location_types.collect { |item| [get_location_type_description(item[0]), item[0]] }
    end
    def self.get_location_type_description(location_type)
      location_type.sub("location_type_", "").humanize
    end
  end
  module UserNetworkEnums
    def self.network_types
      @@network_types_map ||= UserNetwork.network_types.collect { |item| [get_network_type_description(item[0]), item[0]] }
    end
    def self.get_network_type_description(network_type)
      network_type.sub("network_type_", "").humanize
    end
    def self.categories
      @@categories_map ||= UserNetwork.categories.collect { |item| [get_category_description(item[0]), item[0]] }
    end
    def self.get_category_description(category)
      category.sub("category_", "").humanize
    end
  end
  module UserEnums
    def self.get_authentication_method_description(authentication_method)
      authentication_method.sub("authentication_method_", "").humanize
    end
    def self.authentication_methods
      @@authentication_methods_map ||= User.authentication_methods.collect { |item| [get_authentication_method_description(item[0]), item[0]] }
    end
  end
  module HuntingLocationScheduleEnums
    def self.entry_types
      @@entry_types_map ||= HuntingLocationSchedule.entry_types.collect { |item| [get_entry_type_description(item[0]), item[0]] }
    end
    def self.get_entry_type_description(entry_type)
      entry_type.sub("entry_type_", "").humanize
    end
  end
  module UserInvitationEnums
    def self.statuses
      @@statuses_map ||= UserInvitation.statuses.collect { |item| [get_status_description(item[0]), item[0]] }
    end
    def self.get_status_description(status)
      status.sub("status_", "").humanize
    end
  end
end
