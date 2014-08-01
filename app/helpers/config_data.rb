module ConfigData
  def self.user_network_categories
    @@user_network_categories ||= UserNetworkCategory.all.map { |m| { id: m.id, name: m.name, is_composite: m.is_composite } }
  end
end
