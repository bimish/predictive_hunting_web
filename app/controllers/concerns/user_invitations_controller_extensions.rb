module UserInvitationsControllerExtensions

  #class ViewData
  #  def data_element
  #    @data_element ||= xyz
  #  end
  #end

  extend ActiveSupport::Concern

  included do
    #before_action :set_view_data
  end

private

  #def set_view_data
  #  @view_data = ViewData.new()
  #end

end

