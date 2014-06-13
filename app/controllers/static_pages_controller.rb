class StaticPagesController < ApplicationController

  def test
  end

  def home
    @user_posts = UserPost.order(created_at: :desc).limit(10)
    @user_post = UserPost.new
  end

end
