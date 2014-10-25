module UsersControllerExtensions

  class ViewData
    def get_admin_description(admin_value)
      admin_value.to_s
    end
  end

  extend ActiveSupport::Concern

  def set_users
    if (!current_user.admin?)
      @users = User.where(id: current_user.id)
    end
  end

  def after_user_created
    unless signed_in?
      sign_in(@user)
    end
    unless params[:invite_id].blank?
      user_invitation = UserInvitation.find(params[:invite_id])
      user_invitation.accepted(@user)
    end
  end

  def initialize_new_instance
    unless params[:invite_id].blank?
      user_invitation = UserInvitation.find(params[:invite_id])
      unless user_invitation.blank?
        @user.email = user_invitation.email
      end
    end
  end

  def ensure_not_logged_in
    if signed_in? && !current_user.admin?
      store_location
      render 'confirm_signout'
    end
  end

  def action_requires_authenticated_user
    get_crud_action != :create
  end

  included do
    before_action :set_view_data
    prepend_before_action :ensure_not_logged_in, only: [:new, :create]
    before_action :set_users, only: [:index]
    after_action :after_user_created, only: [:create]
    after_initialize_new_instance :initialize_new_instance
  end

private

  def set_view_data
    @view_data = ViewData.new()
  end

end

