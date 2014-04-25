class AnimalActivityObservationsController < ApplicationController

  before_action :set_animal_activity_observation, only: [:show, :edit, :update, :destroy, :delete]
  before_action :set_hunting_plot

  # GET /animal_activity_observations
  # GET /animal_activity_observations.json
  def index
    @animal_activity_observations = AnimalActivityObservation.all
  end

  # GET /animal_activity_observations/1
  # GET /animal_activity_observations/1.json
  def show
  end

  # GET /animal_activity_observations/new
  def new
    @animal_activity_observation = AnimalActivityObservation.new
  end

  # GET /animal_activity_observations/1/edit
  def edit
    @hunting_plot = @animal_activity_observation.hunting_location.hunting_plot
  end

  # POST /animal_activity_observations
  # POST /animal_activity_observations.json
  def create
    @animal_activity_observation = AnimalActivityObservation.new(animal_activity_observation_params)

    respond_to do |format|
      if @animal_activity_observation.save
        format.html { redirect_to @animal_activity_observation, notice: 'Animal activity observation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @animal_activity_observation }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @animal_activity_observation.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /animal_activity_observations/1
  # PATCH/PUT /animal_activity_observations/1.json
  def update
    respond_to do |format|
      if @animal_activity_observation.update(animal_activity_observation_params)
        format.html { redirect_to @animal_activity_observation, notice: 'Animal activity observation was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @animal_activity_observation.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # simply to provide confirmation dialog
  def delete
  end

  # DELETE /animal_activity_observations/1
  # DELETE /animal_activity_observations/1.json
  def destroy
    @animal_activity_observation.destroy
    respond_to do |format|
      format.html { redirect_to animal_activity_observations_url }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal_activity_observation
      @animal_activity_observation = AnimalActivityObservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def animal_activity_observation_params
      params.require(:animal_activity_observation).permit(:hunting_location_id, :animal_category_id, :animal_count, :animal_activity_type_id, :hunting_plot_named_animal_id, :observation_date_time)
    end

    def set_hunting_plot
      @hunting_plot = HuntingPlot.find(params[:hunting_plot_id])
    end
end
