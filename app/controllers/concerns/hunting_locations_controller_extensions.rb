module HuntingLocationsControllerExtensions

  class ViewData

    attr_reader :hunting_plot_id

    def initialize(hunting_plot_id)
      @hunting_plot_id = hunting_plot_id
    end

    def location_types
      @location_types_map ||= HuntingLocation.location_types.collect { |item| [get_location_type_description(item[0]), item[0]] }
    end

    def get_location_type_description(location_type)
      location_type.sub("location_type_", "").humanize
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


