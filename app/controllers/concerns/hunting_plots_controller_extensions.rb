module HuntingPlotsControllerExtensions

  #class ViewData
  #  def data_element
  #    @data_element ||= xyz
  #  end
  #end

  extend ActiveSupport::Concern

  def edit_location
    set_hunting_plot
    render 'hunting_plots/edit_location', layout: 'no-header'
  end

  def manage
    @hunting_plot = get_component
    render layout: "layouts/plot_management"
  end

  def set_hunting_plots
    @hunting_plots = current_user.hunting_plots
  end

  included do
    #before_action :set_view_data
    before_action :set_hunting_plots, only: [:index]
  end

private

  #def set_view_data
  #  @view_data = ViewData.new()
  #end

end

