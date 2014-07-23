module CompositeNetworkMembersControllerExtensions

  class ViewData
    def member_networks
      @member_networks_map ||= UserNetwork.where(network_type: UserNetwork.network_types[:network_type_region]).map { |m| [m.name, m.id] }
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

