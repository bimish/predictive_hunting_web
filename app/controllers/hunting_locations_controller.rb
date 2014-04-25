class HuntingLocationsController < ApplicationController
  before_action :set_hunting_location, only: [:show, :edit, :update, :destroy]

  # GET /hunting_locations
  # GET /hunting_locations.json
  def index
    @hunting_locations = HuntingLocation.all
  end

  # GET /hunting_locations/1
  # GET /hunting_locations/1.json
  def show
  end

  # GET /hunting_locations/new
  def new
    @hunting_location = HuntingLocation.new
    if (params.has_key?(:hunting_plot_id))
    	@hunting_location.hunting_plot_id = params[:hunting_plot_id]
    end
  end

  # GET /hunting_locations/1/edit
  def edit
  end

  # POST /hunting_locations
  # POST /hunting_locations.json
  def create
    @hunting_location = HuntingLocation.new(hunting_location_params)

    respond_to do |format|
      if @hunting_location.save
        format.html { redirect_to @hunting_location, notice: 'Hunting location was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hunting_location }
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hunting_locations/1
  # PATCH/PUT /hunting_locations/1.json
  def update
    respond_to do |format|
      if @hunting_location.update(hunting_location_params)
        format.html { redirect_to @hunting_location, notice: 'Hunting location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hunting_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hunting_locations/1
  # DELETE /hunting_locations/1.json
  def destroy
    @hunting_location.destroy
    respond_to do |format|
      format.html { redirect_to hunting_locations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hunting_location
      @hunting_location = HuntingLocation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hunting_location_params
      params.require(:hunting_location).permit(:name, :coordinates, :hunting_plot_id, :location_type)
    end
end
