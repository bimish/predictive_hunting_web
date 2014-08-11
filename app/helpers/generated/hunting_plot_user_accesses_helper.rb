module Generated
  module HuntingPlotUserAccessesHelper
    def get_user_description(hunting_plot_user_access)
      return hunting_plot_user_access.user.get_display_name
    end
    def get_hunting_plot_description(hunting_plot_user_access)
      return hunting_plot_user_access.hunting_plot.get_display_name
    end
  end
end
