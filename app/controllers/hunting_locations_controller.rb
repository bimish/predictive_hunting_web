class HuntingLocationsController < ApplicationController

  before_action :set_hunting_location, only: [:show, :edit, :update, :destroy, :delete]

  include HuntingLocationsControllerExtensions

  # GET /hunting_locations
  def index
    @hunting_locations = HuntingLocation.all
  end

  # GET /hunting_locations/1
  def show
  end

  # GET /hunting_locations/new
  def new
    @hunting_location = HuntingLocation.new
    @hunting_location.init_new current_user
  end

  # GET /hunting_locations/1/edit
  def edit
  end

  # POST /hunting_locations
  def create
    @hunting_location = HuntingLocation.new(hunting_location_create_params)
    @hunting_location.init_new current_user

    respond_to do |format|
      if @hunting_location.save
        format.html { redirect_to @hunting_location, notice: 'Hunting location was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hunting_location }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_location.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /hunting_locations/1
  def update
    respond_to do |format|
      if @hunting_location.update(hunting_location_update_params)
        format.html { redirect_to @hunting_location, notice: 'Hunting location was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @hunting_location.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /hunting_locations/1
  def destroy
    @hunting_location.destroy
    respond_to do |format|
      format.html { redirect_to hunting_locations_url, notice: 'Hunting location was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hunting_location
      @hunting_location = HuntingLocation.find(params[:id])
    end

    def hunting_location_update_params
      params.require(:hunting_location).permit(:name, :coordinates, :location_type)
    end

    def hunting_location_create_params
      params.require(:hunting_location).permit(:hunting_plot_id, :name, :coordinates, :location_type)
    end

end
