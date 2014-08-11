class HuntingPlotsController < ApplicationController

  before_action :set_hunting_plot, only: [:show, :edit, :update, :destroy]

  # GET /hunting_plots
  # GET /hunting_plots.json
  def index
    #@hunting_plots = HuntingPlot.all
    @hunting_plots = current_user.hunting_plots
  end

  # GET /hunting_plots/1
  # GET /hunting_plots/1.json
  def show
    render 'manage'
  end

  # GET /hunting_plots/new
  def new
    @hunting_plot = HuntingPlot.new
  end

  # GET /hunting_plots/1/edit
  def edit
  end

  # POST /hunting_plots
  # POST /hunting_plots.json
  def create

    @hunting_plot = HuntingPlot.new(hunting_plot_params)

    respond_to do |format|
      if @hunting_plot.save
        format.html { redirect_to @hunting_plot, notice: 'Hunting plot was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hunting_plot }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_plot.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /hunting_plots/1
  # PATCH/PUT /hunting_plots/1.json
  def update
    respond_to do |format|
      if @hunting_plot.update(hunting_plot_params)
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
  # DELETE /hunting_plots/1.json
  def destroy
    @hunting_plot.destroy
    respond_to do |format|
      format.html { redirect_to hunting_plots_url }
      format.json { head :no_content }
    end
  end

  def edit_location
    set_hunting_plot
    render 'hunting_plots/edit_location', layout: 'no-header'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hunting_plot
      @hunting_plot = HuntingPlot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hunting_plot_params
      params.require(:hunting_plot).permit(:name, :location_address, :location_coordinates, :boundary)
    end
end
