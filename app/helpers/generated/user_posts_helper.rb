module Generated
  module UserPostsHelper
    def get_user_description(user_post)
      return user_post.user.get_display_name
    end
  end
end
