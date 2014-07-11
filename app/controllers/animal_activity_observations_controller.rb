class AnimalActivityObservationsController < ApplicationController

  before_action :set_animal_activity_observation, only: [:show, :edit, :update, :destroy, :delete]

  include AnimalActivityObservationsControllerExtensions

  # GET /animal_activity_observations
  def index
    @animal_activity_observations = AnimalActivityObservation.all
  end

  # GET /animal_activity_observations/1
  def show
  end

  # GET /animal_activity_observations/new
  def new
    @animal_activity_observation = AnimalActivityObservation.new
    @animal_activity_observation.init_new current_user
  end

  # GET /animal_activity_observations/1/edit
  def edit
  end

  # POST /animal_activity_observations
  def create
    @animal_activity_observation = AnimalActivityObservation.new(animal_activity_observation_create_params)
    @animal_activity_observation.init_new current_user

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
  def update
    respond_to do |format|
      if @animal_activity_observation.update(animal_activity_observation_update_params)
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

  # DELETE /animal_activity_observations/1
  def destroy
    @animal_activity_observation.destroy
    respond_to do |format|
      format.html { redirect_to animal_activity_observations_url, notice: 'Animal activity observation was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal_activity_observation
      @animal_activity_observation = AnimalActivityObservation.find(params[:id])
    end

    def animal_activity_observation_update_params
      params.require(:animal_activity_observation).permit(:hunting_location_id, :animal_category_id, :animal_count, :animal_activity_type_id, :hunting_plot_named_animal_id, :observation_date_time)
    end

    def animal_activity_observation_create_params
      params.require(:animal_activity_observation).permit(:hunting_location_id, :animal_category_id, :animal_count, :animal_activity_type_id, :hunting_plot_named_animal_id, :observation_date_time)
    end

end
