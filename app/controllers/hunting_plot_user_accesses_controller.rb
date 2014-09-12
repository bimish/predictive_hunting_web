class HuntingPlotUserAccessesController < ComponentController

  include HuntingPlotUserAccessesControllerExtensions

  # GET /hunting_plot_user_accesses
  def index
    @hunting_plot_user_accesses ||= HuntingPlotUserAccess.all
  end

  # GET /hunting_plot_user_accesses/1
  def show
  end

  # GET /hunting_plot_user_accesses/new
  def new
  end

  # GET /hunting_plot_user_accesses/1/edit
  def edit
  end

  # POST /hunting_plot_user_accesses
  def create
    respond_to do |format|
      if @hunting_plot_user_access.save
        format.html { redirect_to @hunting_plot_user_access, notice: 'Hunting plot user access was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hunting_plot_user_access }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_plot_user_access.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /hunting_plot_user_accesses/1
  def update
    respond_to do |format|
      if @hunting_plot_user_access.update(update_params)
        format.html { redirect_to @hunting_plot_user_access, notice: 'Hunting plot user access was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @hunting_plot_user_access.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /hunting_plot_user_accesses/1
  def destroy
    @hunting_plot_user_access.destroy
    respond_to do |format|
      format.html { redirect_to hunting_plot_user_accesses_url, notice: 'Hunting plot user access was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def get_component
      @hunting_plot_user_access = HuntingPlotUserAccess.find(params[:id])
    end

    def new_component(params = nil)
      @hunting_plot_user_access = HuntingPlotUserAccess.new(params)
    end

    def update_params
      params.require(:hunting_plot_user_access).permit(:alias, :permissions_can_administrate, :permissions_can_manage_locations, :permissions_can_manage_members, :permissions_can_manage_named_animals, :permissions_can_manage_schedules)
    end

    def create_params
      params.require(:hunting_plot_user_access).permit(:user_id, :alias, :permissions_can_administrate, :permissions_can_manage_locations, :permissions_can_manage_members, :permissions_can_manage_named_animals, :permissions_can_manage_schedules)
    end

end
