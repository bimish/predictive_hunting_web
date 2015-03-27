module HuntingLocationsControllerExtensions

  class ViewData

    attr_reader :hunting_plot_id

    def initialize(hunting_plot_id)
      @hunting_plot_id = hunting_plot_id
    end

  end

  extend ActiveSupport::Concern

  def initialize_new_instance
    @hunting_location.hunting_plot_id = params[:hunting_plot_id]
    unless params[:location_type].blank?
      @hunting_location.location_type = params[:location_type].to_i
    end
  end

  included do
    before_action :set_view_data
    after_initialize_new_instance :initialize_new_instance
  end

private

  def set_view_data
    @view_data = ViewData.new(params[:hunting_plot_id])
  end

end


