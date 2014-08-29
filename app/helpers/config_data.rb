module ConfigData
  def self.user_network_categories
    @@user_network_categories ||= UserNetworkCategory.all.map { |m| { id: m.id, name: m.name, is_composite: m.is_composite } }
  end
  def self.animal_categories
    @@animal_categories ||= AnimalCategory.all.each_with_object({}) do |category, hash|
      hash[category.id] =
        {
          id: category.id,
          name: category.name,
          gender: category.gender,
          maturity: category.maturity,
          trophy_rating: category.trophy_rating
        }
    end
  end
  def self.animal_activity_types
    @@animal_activity_types ||= AnimalActivityType.all.each_with_object({}) do |activity_type, hash|
      hash[activity_type.id] =
        {
          id: activity_type.id,
          name: activity_type.name
        }
    end
  end
end
