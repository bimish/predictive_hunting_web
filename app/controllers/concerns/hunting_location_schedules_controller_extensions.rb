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

  extend ActiveSupport::Concern

  included do
    before_action :set_view_data
    after_initialize_new_instance :initialize_new_instance
  end

private

  def set_view_data
    @view_data = ViewData.new(params[:hunting_location_id])
  end

end

