class HuntingLocationReservationsController < ComponentController

  before_action :set_view_data

  class ViewData

    attr_accessor :vantage_point

    def initialize(reservation, hunting_plot_id, hunting_location_id)
      @reservation = reservation
      @hunting_plot_id = hunting_plot_id
      @hunting_location_id = hunting_location_id
    end

    def hunting_location
      if !@reservation.nil?
        @hunting_location = @reservation.hunting_location
      elsif @hunting_location.nil? && !@hunting_location_id.nil?
        @hunting_location = HuntingLocation.find(@hunting_location_id)
      end
      @hunting_location
    end

    def hunting_plot
      if @hunting_plot.nil?
        if @hunting_plot_id.nil?
          @hunting_plot = self.hunting_location.hunting_plot
        else
          @hunting_plot = HuntingPlot.find(@hunting_plot_id)
        end
      end
      @hunting_plot
    end

    def hunting_locations
      @hunting_locations_map ||= self.hunting_plot.locations.where(location_type: HuntingLocation.location_types[:location_type_stand]).order(name: :asc).map { |m| [m.name, m.id] }
    end

  end

  def index
    @reservations = HuntingLocationReservation.search(params[:hunting_plot_id], { }).order(start_date_time: :asc).preload(:created_by).preload(:hunting_location).paginate(page: params[:page]).per_page(10)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
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
  end

  def update
    respond_to do |format|
      if @reservation.update(update_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to hunting_stand_reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  def search
    @reservations = HuntingLocationReservation.search(params[:hunting_plot_id], params).preload(:created_by).preload(:hunting_location).paginate(page: params[:page]).per_page(10)
    @additional_paging_parameters = {}
    @additional_paging_parameters[:hunting_location_id] = params[:hunting_location_id] unless params[:hunting_location_id].blank?
    @additional_paging_parameters[:created_by_user_id] = params[:created_by_user_id] unless params[:created_by_user_id].blank?
    @additional_paging_parameters[:reservation_date] = params[:reservation_date] unless params[:reservation_date].blank?
    @additional_paging_parameters[:reservation_date_operator] = params[:reservation_date_operator] unless params[:reservation_date_operator].blank?
  end

  private
    def get_component
      @reservation ||= HuntingLocationReservation.find(params[:id])
    end

    def new_component(params = nil)
      @reservation = HuntingLocationReservation.new(params)
    end

    def update_params
      params.require(:hunting_location_reservation).permit(:hunting_location_id, :reservation_date, :time_period, :start_time, :end_time)
    end

    def create_params
      params.require(:hunting_location_reservation).permit(:hunting_location_id, :reservation_date, :time_period, :start_time, :end_time)
    end

    def set_view_data
      @view_data = ViewData.new(params[:id].blank? ? nil : get_component, params[:hunting_plot_id], params[:hunting_location_id])
    end

end
