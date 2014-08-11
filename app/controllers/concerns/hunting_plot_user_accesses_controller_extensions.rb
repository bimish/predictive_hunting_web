module HuntingPlotUserAccessesControllerExtensions

  class ViewData
    def users
      @users_map ||= User.all.map { |m| [m.get_display_name(), m.id] }
    end
  end

  extend ActiveSupport::Concern

  included do
    before_action :set_view_data
  end

private

  def set_view_data
    @view_data = ViewData.new()
  end

end

