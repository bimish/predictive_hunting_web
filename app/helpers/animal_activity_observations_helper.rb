module AnimalActivityObservationsHelper
  def get_named_animal_list
    return @hunting_plot.named_animals.map { |m| [m.name, m.id] }
  end
  def get_named_animal_description(observation)
    return observation.named_animal.nil? ? '' : observation.named_animal.name
  end
end
