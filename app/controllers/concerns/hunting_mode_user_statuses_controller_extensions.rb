module HuntingModeUserStatusesControllerExtensions

  #class ViewData
  #  def data_element
  #    @data_element ||= xyz
  #  end
  #end

  extend ActiveSupport::Concern

  def initialize_new_instance
    @hunting_mode_user_status.hunting_plot_id = params[:hunting_plot_id]
    @hunting_mode_user_status.status_type = params[:status_type]
  end

  def set_return_format
    if request.format.js?
      @return_html = (params[:return_html] != 'false')
    end
  end

  included do
    #before_action :set_view_data
    after_action :set_return_format
    after_initialize_new_instance :initialize_new_instance
  end

private

  #def set_view_data
  #  @view_data = ViewData.new()
  #end

end

