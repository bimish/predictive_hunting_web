module HuntingLocationSchedulesControllerExtensions

  class ViewData
    attr_reader :hunting_location_id
    def initialize(hunting_location_id)
      @hunting_location_id = hunting_location_id
    end
    def hunting_location
      @hunting_location ||= HuntingLocation.find(@hunting_location_id)
    end
  end

  # controller assign-properties
  def initialize_new_instance
    @hunting_location_schedule.hunting_location_id = params[:hunting_location_id]
  end

  def set_hunting_location_schedules
    @hunting_location_schedule = HuntingLocation.find(params[:hunting_location_id]).schedules
  end

  extend ActiveSupport::Concern

  included do
    before_action :set_view_data
    before_action :set_hunting_location_schedules, only: [:index]
    after_initialize_new_instance :initialize_new_instance
  end

private

  def set_view_data
    @view_data = ViewData.new(params[:hunting_location_id])
  end

end

