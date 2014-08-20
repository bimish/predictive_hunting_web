module HuntingPlotUserAccessesHelper
  def self.get_permissions_description(hunting_plot_user_access)
    enabled_permissions = Array.new
    if (hunting_plot_user_access.permissions_can_administrate?)
      enabled_permissions.push 'Administrate'
    end
    if (hunting_plot_user_access.permissions_can_manage_members?)
      enabled_permissions.push 'Manage Members'
    end
    if (hunting_plot_user_access.permissions_can_manage_locations?)
      enabled_permissions.push 'Manage Locations'
    end
    enabled_permissions.join(', ')
  end
end
