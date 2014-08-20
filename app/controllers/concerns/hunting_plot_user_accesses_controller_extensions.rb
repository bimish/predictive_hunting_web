module HuntingPlotUserAccessesControllerExtensions

  class ViewData
    def users
      @users_map ||= User.all.map { |m| [m.get_display_name(), m.id] }
    end
  end

  extend ActiveSupport::Concern

  # controller assign-properties
  def initialize_new_instance
    @hunting_plot_user_access.hunting_plot_id = params[:hunting_plot_id]
  end

  def set_hunting_plot_user_accesses
    @hunting_plot_user_accesses = HuntingPlot.find(params[:hunting_plot_id]).user_accesses
  end

  included do
    before_action :set_view_data
    before_action :set_hunting_plot_user_accesses, only: [:index]
    after_initialize_new_instance :initialize_new_instance
  end

private

  def set_view_data
    @view_data = ViewData.new()
  end

end

