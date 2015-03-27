module HuntingLocationSchedulesControllerExtensions

  class ViewData

    attr_accessor :vantage_point

    def initialize(hunting_plot_id, hunting_location_id)
      @hunting_plot_id = hunting_plot_id
      @hunting_location_id = hunting_location_id
    end

    def hunting_location
      if @hunting_location.nil? && !@hunting_location_id.nil?
        @hunting_location = HuntingLocation.find(@hunting_location_id)
      end
      @hunting_location
    end

    def hunting_plot
      if @hunting_plot.nil?
        if @hunting_plot_id.nil?
          @hunting_plot = self.hunting_location.hunting_plot
        else
          @hunting_plot = HuntingPlot.find(@hunting_plot_id)
        end
      end
      @hunting_plot
    end

    def hunting_locations
      @hunting_locations_map ||= self.hunting_plot.locations.map { |m| [m.name, m.id] }
    end

  end

  # controller assign-properties
  def initialize_new_instance
    unless params[:hunting_location_id].blank?
      @hunting_location_schedule.hunting_location_id = params[:hunting_location_id]
    end
  end

  def set_hunting_location_schedules
    @hunting_location_schedules = HuntingLocation.find(params[:hunting_location_id]).schedules
    @view_data.vantage_point = :location
  end

  extend ActiveSupport::Concern

  included do
    before_action :set_view_data
    before_action :set_hunting_location_schedules, only: [:index]
    after_initialize_new_instance :initialize_new_instance
  end

  def search

  end

private

  def set_view_data
    @view_data = ViewData.new(params[:hunting_plot_id], params[:hunting_location_id])
  end

end

