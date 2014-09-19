module NestedUrlsHelper
  def user_network_composite_network_member_path(*args)
    composite_network_member_path(args[1])
  end
  def user_network_composite_network_members_path(*args)
    user_network_members_path(args[0], args[1])
  end
  def new_hunting_plot_hunting_location_path(*args)
    new_hunting_plot_location_path(args[0])
  end
  def hunting_plot_hunting_locations_path(*args)
    hunting_plot_locations_path(args[0])
  end
  def hunting_plot_hunting_location_path(*args)
    hunting_location_path(args[1])
  end
=begin
  def hunting_plot_hunting_locations_path(*args)
    hunting_locations_path(args[0], args[1])
  end
=end
end
