class HuntingLocationSchedulesController < ComponentController

  include HuntingLocationSchedulesControllerExtensions

  # GET /hunting_location_schedules
  def index
    @hunting_location_schedules ||= HuntingLocationSchedule.all
  end

  # GET /hunting_location_schedules/1
  def show
  end

  # GET /hunting_location_schedules/new
  def new
  end

  # GET /hunting_location_schedules/1/edit
  def edit
  end

  # POST /hunting_location_schedules
  def create
    respond_to do |format|
      if @hunting_location_schedule.save
        format.html { redirect_to @hunting_location_schedule, notice: 'Hunting location schedule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hunting_location_schedule }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_location_schedule.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /hunting_location_schedules/1
  def update
    respond_to do |format|
      if @hunting_location_schedule.update(update_params)
        format.html { redirect_to @hunting_location_schedule, notice: 'Hunting location schedule was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @hunting_location_schedule.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /hunting_location_schedules/1
  def destroy
    @hunting_location_schedule.destroy
    respond_to do |format|
      format.html { redirect_to hunting_location_schedules_url, notice: 'Hunting location schedule was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def get_component
      @hunting_location_schedule = HuntingLocationSchedule.find(params[:id])
    end

    def new_component(params = nil)
      @hunting_location_schedule = HuntingLocationSchedule.new(params)
    end

    def update_params
      params.require(:hunting_location_schedule).permit(:start_date_time, :end_date_time, :entry_type, :time_period)
    end

    def create_params
      params.require(:hunting_location_schedule).permit(:start_date_time, :end_date_time, :entry_type, :time_period)
    end

end
