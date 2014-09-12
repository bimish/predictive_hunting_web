class HuntingPlotsController < ComponentController

  include HuntingPlotsControllerExtensions

  # GET /hunting_plots
  def index
    @hunting_plots ||= HuntingPlot.all
  end

  # GET /hunting_plots/1
  def show
  end

  # GET /hunting_plots/new
  def new
  end

  # GET /hunting_plots/1/edit
  def edit
  end

  # POST /hunting_plots
  def create
    respond_to do |format|
      if @hunting_plot.save
        format.html { redirect_to @hunting_plot, notice: 'Hunting plot was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hunting_plot }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_plot.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /hunting_plots/1
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

  # DELETE /hunting_plots/1
  def destroy
    @hunting_plot.destroy
    respond_to do |format|
      format.html { redirect_to hunting_plots_url, notice: 'Hunting plot was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def get_component
      @hunting_plot = HuntingPlot.find(params[:id])
    end

    def new_component(params = nil)
      @hunting_plot = HuntingPlot.new(params)
    end

    def update_params
      params.require(:hunting_plot).permit(:name, :location_address, :location_coordinates, :boundary)
    end

    def create_params
      params.require(:hunting_plot).permit(:name, :location_address, :location_coordinates, :boundary)
    end

end
