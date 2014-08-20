module HuntingPlotNamedAnimalsControllerExtensions

  class ViewData

    attr_reader :hunting_plot_id

    def initialize(hunting_plot_id)
      @hunting_plot_id = hunting_plot_id
    end

    def animal_categories
      @animal_categories_map ||= AnimalCategory.all.map { |m| [m.name, m.id] }
    end

  end

  # controller assign-properties
  def initialize_new_instance
    @hunting_plot_named_animal.hunting_plot_id = params[:hunting_plot_id]
  end

  def set_hunting_plot_named_animals
    @hunting_plot_named_animals = HuntingPlot.find(params[:hunting_plot_id]).named_animals
  end

  extend ActiveSupport::Concern

  included do
    before_action :set_view_data
    before_action :set_hunting_plot_named_animals, only: [:index]
    after_initialize_new_instance :initialize_new_instance
  end

private

  def set_view_data
    @view_data = ViewData.new(params[:hunting_plot_id])
  end

end

