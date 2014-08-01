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
end
