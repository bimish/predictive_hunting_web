module UserGroupsControllerExtensions

  #class ViewData
  #  def data_element
  #    @data_element ||= xyz
  #  end
  #end

  extend ActiveSupport::Concern

  def initialize_new_instance
    @user_group.hunting_plot_id = params[:hunting_plot_id]
  end

  included do
    #before_action :set_view_data
    after_initialize_new_instance :initialize_new_instance
  end

private

  #def set_view_data
  #  @view_data = ViewData.new()
  #end

end

