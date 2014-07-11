module AnimalActivityObservationsControllerExtensions

  class ViewData

    attr_reader :hunting_plot

    def initialize(hunting_plot)
      @hunting_plot = hunting_plot
    end

    def hunting_locations
      @locations_map ||= @hunting_plot.locations.map { |m| [m.name, m.id] }
    end

    def animal_categories
      @animal_categories_map ||= AnimalCategory.all.map { |m| [m.name, m.id] }
    end

    def animal_activity_types
      @animal_activity_types_map ||= AnimalActivityType.all.map { |m| [m.name, m.id] }
    end

    def named_animals
      @named_animals ||= @hunting_plot.named_animals.map { |m| [m.name, m.id] }
    end

  end

  extend ActiveSupport::Concern

  included do
    append_before_action :set_hunting_plot
    append_before_action :set_view_data
  end

private

  def set_hunting_plot
    @hunting_plot = get_hunting_plot
  end

  def get_hunting_plot
    if (@animal_activity_observation.nil?)
      HuntingPlot.find(params[:hunting_plot_id])
    else
      @animal_activity_observation.hunting_location.hunting_plot
    end
  end

  def set_view_data
    hunting_plot = nil
    if (@animal_activity_observation.nil?)
      hunting_plot = HuntingPlot.find(params[:hunting_plot_id])
    else
      hunting_plot = @animal_activity_observation.hunting_location.hunting_plot
    end
    @view_data = ViewData.new(hunting_plot)
  end

end

