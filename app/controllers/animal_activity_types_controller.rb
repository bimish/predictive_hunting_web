class AnimalActivityTypesController < ApplicationController

  before_action :set_animal_activity_type, only: [:show, :edit, :update, :destroy]

  # GET /animal_activity_types
  # GET /animal_activity_types.json
  def index
    @animal_activity_types = AnimalActivityType.all
  end

  # GET /animal_activity_types/1
  # GET /animal_activity_types/1.json
  def show
  end

  # GET /animal_activity_types/new
  def new
    @animal_activity_type = AnimalActivityType.new
  end

  # GET /animal_activity_types/1/edit
  def edit
  end

  # POST /animal_activity_types
  # POST /animal_activity_types.json
  def create
    @animal_activity_type = AnimalActivityType.new(animal_activity_type_params)

    respond_to do |format|
      if @animal_activity_type.save
        format.html { redirect_to @animal_activity_type, notice: 'Animal activity type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @animal_activity_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @animal_activity_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animal_activity_types/1
  # PATCH/PUT /animal_activity_types/1.json
  def update
    respond_to do |format|
      if @animal_activity_type.update(animal_activity_type_params)
        format.html { redirect_to @animal_activity_type, notice: 'Animal activity type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @animal_activity_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animal_activity_types/1
  # DELETE /animal_activity_types/1.json
  def destroy
    @animal_activity_type.destroy
    respond_to do |format|
      format.html { redirect_to animal_activity_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal_activity_type
      @animal_activity_type = AnimalActivityType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def animal_activity_type_params
      params.require(:animal_activity_type).permit(:name)
    end
end
