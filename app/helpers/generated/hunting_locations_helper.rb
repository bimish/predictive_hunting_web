module Generated
  module HuntingLocationsHelper
    def get_hunting_plot_description(hunting_location)
      return hunting_location.hunting_plot.get_display_name
    end
  end
end
