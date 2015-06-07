class PlotManagementController < ApplicationController

  before_filter :ensure_signed_in
  #before_filter :correct_user, only: [:edit, :update, :destroy]

  before_action :set_hunting_plot
  before_action :check_plot_access
  #before_action :authorize_action, only: [:show, :edit, :update, :destroy, :delete ]

  layout 'layouts/plot_management'

  def home

  end

  def members
    @hunting_plot_user_accesses = @hunting_plot.user_accesses.preload(:user).joins(:user).order('"user"."first_name" ASC, "user"."last_name" ASC')
  end

  def member_invitations
    @hunting_plot_user_access_requests = @hunting_plot.user_access_requests.preload(:user).preload(:user_invitation).order(:id)
  end

  def user_groups
    @user_groups = @hunting_plot.user_groups.order(name: :asc)
  end

  def stands_list
    @stands = @hunting_plot.locations.where(location_type: HuntingLocation.location_types[:location_type_stand]).order(name: :asc)
  end

  def stands_map
    @stands = @hunting_plot.locations.where(location_type: HuntingLocation.location_types[:location_type_stand])
  end

  def stand_access
    @stand_accesses = @hunting_plot.locations.where(location_type: HuntingLocation.location_types[:location_type_stand]).preload(:user_accesses).preload(:user_group_accesses).order(name: :asc)
  end

  def edit_stand_access
    set_stand

    plot_members = @hunting_plot.users.order(first_name: :asc, last_name: :asc)
    existing_access_users = @stand.user_accesses.pluck(:user_id)
    @users = plot_members.collect do |user|
      {
        id: user.id,
        name: user.get_display_name,
        has_access: existing_access_users.include?(user.id)
      }
    end

    plot_groups = @hunting_plot.user_groups.order(name: :asc)
    existing_access_groups = @stand.user_group_accesses.pluck(:user_group_id)
    @user_groups = plot_groups.collect do |user_group|
      {
        id: user_group.id,
        name: user_group.get_display_name,
        has_access: existing_access_groups.include?(user_group.id)
      }
    end

    render "plot_management/stand_access/edit"
=begin
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_group_member }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
=end
  end

  def update_stand_access

    set_stand

    unless @stand.update(params.require(:hunting_location).permit(:access_flags_public, :access_flags_accepts_requests))
      respond_to do |format|
        format.html { render action: 'edit' }
        format.json { render json: @hunting_location.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end

    user_ids = params[:access_user_id]
    unless user_ids.nil?
      user_ids.collect! { |id| id.to_i }
    end
    @stand.set_user_access(user_ids)

    user_group_ids = params[:access_user_group_id]
    unless user_group_ids.nil?
      user_group_ids.collect! { |id| id.to_i }
    end
    @stand.set_user_group_access(user_group_ids)

    render "plot_management/stand_access/update"

  end

  def named_animals

  end

  def stand_reservations
    @stands = @hunting_plot.locations.where(location_type: HuntingLocation.location_types[:location_type_stand]).order(name: :asc).map { |item| [item.name, item.id ] }
    @users = @hunting_plot.user_accesses.preload(:user).joins(:user).order('"user"."first_name" ASC, "user"."last_name" ASC').map { |item| [item.user.get_display_name, item.user_id ] }
    @reservations = HuntingLocationReservation.search(@hunting_plot.id, { reservation_date: Date.today.to_s, reservation_date_operator: 'after' }).paginate(page: 1).per_page(10)
    @additional_paging_parameters = {}
    @additional_paging_parameters[:reservation_date] = Date.today.to_s
    @additional_paging_parameters[:reservation_date_operator] = 'after'
  end

  def activity_log

  end

private

  def set_hunting_plot
    @hunting_plot = HuntingPlot.find(params[:hunting_plot_id])
  end

  def set_stand
    @stand = @hunting_plot.locations.find(params[:hunting_location_id])
  end

  def check_plot_access
    raise Exceptions::NotAuthorized unless HuntingPlotUserAccess.can_access?(@hunting_plot.id, current_user.id)
  end

end
