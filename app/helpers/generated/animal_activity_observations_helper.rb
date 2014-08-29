module Generated
  module AnimalActivityObservationsHelper
    def get_hunting_plot_description(animal_activity_observation)
      return animal_activity_observation.hunting_plot.get_display_name
    end
    def get_hunting_location_description(animal_activity_observation)
      return animal_activity_observation.hunting_location.get_display_name
    end
    def get_animal_category_description(animal_activity_observation)
      return animal_activity_observation.animal_category.get_display_name
    end
    def get_animal_activity_type_description(animal_activity_observation)
      return animal_activity_observation.animal_activity_type.get_display_name
    end
    def get_named_animal_description(animal_activity_observation)
      return animal_activity_observation.named_animal.get_display_name
    end
    def get_created_by_description(animal_activity_observation)
      return animal_activity_observation.created_by.get_display_name
    end
  end
end
