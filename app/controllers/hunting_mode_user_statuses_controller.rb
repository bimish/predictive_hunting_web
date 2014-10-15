class HuntingModeUserStatusesController < ComponentController

  include HuntingModeUserStatusesControllerExtensions

  # GET /hunting_mode_user_statuses
  def index
    @hunting_mode_user_statuses ||= HuntingModeUserStatus.all
  end

  # GET /hunting_mode_user_statuses/1
  def show
  end

  # GET /hunting_mode_user_statuses/new
  def new
  end

  # GET /hunting_mode_user_statuses/1/edit
  def edit
  end

  # POST /hunting_mode_user_statuses
  def create
    respond_to do |format|
      if @hunting_mode_user_status.save
        format.html { redirect_to @hunting_mode_user_status, notice: 'Hunting mode user status was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hunting_mode_user_status }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_mode_user_status.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /hunting_mode_user_statuses/1
  def update
    respond_to do |format|
      if @hunting_mode_user_status.update(update_params)
        format.html { redirect_to @hunting_mode_user_status, notice: 'Hunting mode user status was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @hunting_mode_user_status.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /hunting_mode_user_statuses/1
  def destroy
    @hunting_mode_user_status.destroy
    respond_to do |format|
      format.html { redirect_to hunting_mode_user_statuses_url, notice: 'Hunting mode user status was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def get_component
      @hunting_mode_user_status = HuntingModeUserStatus.find(params[:id])
    end

    def new_component(params = nil)
      @hunting_mode_user_status = HuntingModeUserStatus.new(params)
    end

    def update_params
      params.require(:hunting_mode_user_status).permit(:status_text)
    end

    def create_params
      params.require(:hunting_mode_user_status).permit(:status_text)
    end

end
