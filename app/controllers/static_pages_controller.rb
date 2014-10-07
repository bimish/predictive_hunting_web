class StaticPagesController < ApplicationController

  def test
    @user_post = UserPost.new()
  end

  def network_panel
    hunting_plot = HuntingPlot.find(params[:network_id])
    render :partial => 'shared/network_panel', locals: { :hunting_plot => hunting_plot }
  end

  def home
    @user_posts = UserPost.from_related_users(current_user).order(id: :desc).limit(10)
    @user_post = UserPost.new
  end

end
