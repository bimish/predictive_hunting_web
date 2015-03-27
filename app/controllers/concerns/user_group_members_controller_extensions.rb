module UserGroupMembersControllerExtensions

  #class ViewData
  #  def data_element
  #    @data_element ||= xyz
  #  end
  #end

  extend ActiveSupport::Concern

  def initialize_new_instance
    @user_group_member.user_group_id = params[:user_group_id]
  end

  included do
    #before_action :set_view_data
    before_action :set_user_group, only: [:select, :set]
    after_initialize_new_instance :initialize_new_instance
  end

  def select
    set_users_list
  end

  def set
    user_ids = params[:user_id].collect { |id| id.to_i }
    @user_group.set_members(user_ids)
    respond_to do |format|
      format.html {
        set_users_list
        flash[:success] = "Changes saved"
        redirect_to select_user_group_members_path(@user_group)
      }
      format.json { head :no_content }
      format.js
    end
  end

private
  def set_users_list
    plot_members = @user_group.hunting_plot.users.order(first_name: :asc, last_name: :asc)
    existing_group_members = @user_group.members.pluck(:user_id)
    @users = plot_members.collect do |user|
      {
        id: user.id,
        name: user.get_display_name,
        is_member: existing_group_members.include?(user.id)
      }
    end
  end

  def set_user_group
    @user_group = UserGroup.find(params[:user_group_id])
  end

  #def set_view_data
  #  @view_data = ViewData.new()
  #end

end

