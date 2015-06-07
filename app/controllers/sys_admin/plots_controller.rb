module SysAdmin

  class PlotsController < AdminController

    before_filter :ensure_signed_in, only: [:index, :edit, :update, :destroy]

    before_action :set_hunting_plot, only: [:show, :edit, :update, :destroy, :delete]
    before_action :authorize_action, only: [:show, :edit, :update, :destroy, :delete]

    # GET /sysadmin/plots
    def index
      @hunting_plots = HuntingPlot.all
    end

    # GET /sysadmin/plots
    def show
    end

    # GET /sysadmin/plots/new
    def new
      @hunting_plot = HuntingPlot.new
    end

    # POST /sysadmin/plots/new
    def create
      @hunting_plot = HuntingPlot.new(create_params)

      respond_to do |format|
        if @hunting_plot.save
          format.html { redirect_to @hunting_plot, notice: 'Hunting plot was successfully created.' }
          format.json { render action: 'show', status: :created, location: @hunting_plot }
        else
          format.html { render action: 'new' }
          format.json { render json: @hunting_plot.errors, status: :unprocessable_entity }
        end
      end
    end

    # GET /sysadmin/plots/1/edit
    def edit
    end

    # PATCH/PUT /sysadmin/plots/1
    def update
      respond_to do |format|
        if @hunting_plot.update(update_params)
          format.html { redirect_to @hunting_plot, notice: 'Hunting plot was successfully updated.' }
          format.json { head :no_content }
          format.js
        else
          format.html { render action: 'edit' }
          format.json { render json: @hunting_plot.errors, status: :unprocessable_entity }
          format.js { render action: 'edit' }
        end
      end
    end

    # DELETE /sysadmin/plots/1
    def destroy
      @hunting_plot.destroy
      respond_to do |format|
        format.html { redirect_to hunting_plots_url, notice: 'Hunting plot was successfully destroyed.' }
        format.json { head :no_content }
        format.js
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_hunting_plot
        @hunting_plot = HuntingPlot.find(params[:id])
      end

      def update_params
        params.require(:hunting_plot).permit(:name, :location_address, :location_coordinates, :boundary)
      end

      def create_params
        params.require(:hunting_plot).permit(:name, :location_address, :location_coordinates, :boundary)
      end

      def authorize_action
        raise Exceptions::NotAuthorized unless @user_relationship.authorize_action?(current_user, params[:action].to_sym)
      end

  end

end
