module Generated
  module HuntingPlotNamedAnimalHelper
    def get_hunting_plot_description(hunting_plot_named_animal)
      return hunting_plot_named_animal.hunting_plot.get_display_name
    end
    def get_animal_category_description(hunting_plot_named_animal)
      return hunting_plot_named_animal.animal_category.get_display_name
    end
  end
end
