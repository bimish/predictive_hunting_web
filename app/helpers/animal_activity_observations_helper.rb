module AnimalActivityObservationsHelper
  #include Generated::AnimalActivityObservationsHelper
  def get_hunting_location_list_items
    return @hunting_plot.locations.map { |m| [m.name, m.id] }
  end
  def get_hunting_location_description(animal_activity_observation)
    animal_activity_observation.hunting_location.name
  end
  def get_animal_category_list_items
    AnimalCategory.all.map { |m| [m.name, m.id] }
  end
  def get_animal_category_description(animal_activity_observation)
    animal_activity_observation.animal_category.name
  end
  def get_animal_activity_type_list_items
    return AnimalActivityType.all.map { |m| [m.name, m.id] }
  end
  def get_animal_activity_type_description(animal_activity_observation)
    animal_activity_observation.animal_activity_type.name
  end
  def get_named_animal_list_items
    return @hunting_plot.named_animals.map { |m| [m.name, m.id] }
  end
  def get_named_animal_description(animal_activity_observation)
    return animal_activity_observation.named_animal.nil? ? '' : animal_activity_observation.named_animal.name
  end
  def get_created_by_list_items

  end
  def get_created_by_description(animal_activity_observation)
    return animal_activity_observation.created_by.get_display_name
  end

  def animal_category_field(form_helper)
    form_helper.select :animal_category_id, @view_data.animal_categories, { label:'Animal category', include_blank:'[Animal category]' }
  end

end
