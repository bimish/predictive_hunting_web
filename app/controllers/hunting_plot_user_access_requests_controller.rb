class HuntingPlotUserAccessRequestsController < ComponentController

  include HuntingPlotUserAccessRequestsControllerExtensions

  # GET /hunting_plot_user_access_requests
  def index
    @hunting_plot_user_access_requests ||= HuntingPlotUserAccessRequest.all
  end

  # GET /hunting_plot_user_access_requests/1
  def show
  end

  # GET /hunting_plot_user_access_requests/new
  def new
  end

  # GET /hunting_plot_user_access_requests/1/edit
  def edit
  end

  # POST /hunting_plot_user_access_requests
  def create
    respond_to do |format|
      if @hunting_plot_user_access_request.save
        format.html { redirect_to @hunting_plot_user_access_request, notice: 'Hunting plot user access request was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hunting_plot_user_access_request }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_plot_user_access_request.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /hunting_plot_user_access_requests/1
  def update
    respond_to do |format|
      if @hunting_plot_user_access_request.update(update_params)
        format.html { redirect_to @hunting_plot_user_access_request, notice: 'Hunting plot user access request was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @hunting_plot_user_access_request.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /hunting_plot_user_access_requests/1
  def destroy
    @hunting_plot_user_access_request.destroy
    respond_to do |format|
      format.html { redirect_to hunting_plot_user_access_requests_url, notice: 'Hunting plot user access request was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def get_component
      @hunting_plot_user_access_request = HuntingPlotUserAccessRequest.find(params[:id])
    end

    def new_component(params = nil)
      @hunting_plot_user_access_request = HuntingPlotUserAccessRequest.new(params)
    end

    def update_params
      params.require(:hunting_plot_user_access_request).permit(:message, :alias, :initial_permissions_can_administrate, :initial_permissions_can_manage_locations, :initial_permissions_can_manage_members, :initial_permissions_can_manage_named_animals, :initial_permissions_can_manage_schedules)
    end

    def create_params
      params.require(:hunting_plot_user_access_request).permit(:user_id, :user_invitation_id, :message, :alias, :initial_permissions_can_administrate, :initial_permissions_can_manage_locations, :initial_permissions_can_manage_members, :initial_permissions_can_manage_named_animals, :initial_permissions_can_manage_schedules)
    end

end
