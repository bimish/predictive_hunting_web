module UserPostsControllerExtensions

  #class ViewData
  #  def data_element
  #    @data_element ||= xyz
  #  end
  #end

  extend ActiveSupport::Concern

  def set_user_posts
    @user_posts = UserPost.from_related_users(current_user).limit(25)
  end

  def feed_items

    options = {}

    if params[:since_id]
      options[:since_id] = params[:since_id]
      @action = 'insert'
    elsif params[:before_id]
      options[:before_id] = params[:before_id]
      @action = 'append'
    else
      @action = 'list'
    end

    @user_posts = UserPost.from_related_users(current_user, options).order(id: :desc).limit(25)

  end

  included do
    #before_action :set_view_data
    before_action :set_user_posts, only: [:index]
  end

private

  #def set_view_data
  #  @view_data = ViewData.new()
  #end

end

