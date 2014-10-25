class StaticPagesController < ApplicationController

  before_action :ensure_signed_in

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

  def router
    if (current_user.hunting_plots.size() == 0)
      redirect_to home_path
    else
      redirect_to hunting_app_path(current_user.hunting_plots.first)
    end
  end

end
