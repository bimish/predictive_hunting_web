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

  extend ActiveSupport::Concern

  included do
    before_action :set_view_data
  end

private

  def set_view_data
    @view_data = ViewData.new(params[:hunting_plot_id])
  end

end

