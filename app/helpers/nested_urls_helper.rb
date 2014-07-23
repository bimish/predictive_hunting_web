module NestedUrlsHelper
  def user_network_composite_network_member_path(*args)
    composite_network_member_path(args[1])
  end
  def user_network_composite_network_members_path(*args)
    user_network_members_path(args[0], args[1])
  end
end
