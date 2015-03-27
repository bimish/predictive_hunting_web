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

  def check_plot_access
    raise Exceptions::NotAuthorized unless HuntingPlotUserAccess.can_access?(@hunting_plot.id, current_user.id)
  end

end
