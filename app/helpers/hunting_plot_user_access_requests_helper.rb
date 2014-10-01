module HuntingPlotUserAccessRequestsHelper
  def self.get_initial_permissions_description(hunting_plot_user_access_request)
    enabled_permissions = Array.new
    if (hunting_plot_user_access_request.initial_permissions_can_administrate?)
      enabled_permissions.push 'Administrate'
    end
    if (hunting_plot_user_access_request.initial_permissions_can_manage_members?)
      enabled_permissions.push 'Manage Members'
    end
    if (hunting_plot_user_access_request.initial_permissions_can_manage_locations?)
      enabled_permissions.push 'Manage Locations'
    end
    if (hunting_plot_user_access_request.initial_permissions_can_manage_schedules?)
      enabled_permissions.push 'Manage Schedules'
    end
    enabled_permissions.join(', ')
  end
end
