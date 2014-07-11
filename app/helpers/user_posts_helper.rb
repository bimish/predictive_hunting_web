module UserPostsHelper
  #include Generated::UserPostsHelper
  def get_user_list_items()
    User.all.map { |u| [u.alias, u.id] }
  end
  def get_visibility_list_items()
    DataDomains::UserPostVisibility
  end
  def get_visibility_description(user_post)
    DataDomains::UserPostVisibility.key(user_post.visibility)
  end
end
