class AnimalSpeciesController < ApplicationController
  before_action :set_animal_species, only: [:show, :edit, :update, :destroy]

  # GET /animal_species
  # GET /animal_species.json
  def index
    @animal_species = AnimalSpecies.all
  end

  # GET /animal_species/1
  # GET /animal_species/1.json
  def show
  end

  # GET /animal_species/new
  def new
    @animal_species = AnimalSpecies.new
  end

  # GET /animal_species/1/edit
  def edit
  end

  # POST /animal_species
  # POST /animal_species.json
  def create
    @animal_species = AnimalSpecies.new(animal_species_params)

    respond_to do |format|
      if @animal_species.save
        format.html { redirect_to @animal_species, notice: 'Animal species was successfully created.' }
        format.json { render action: 'show', status: :created, location: @animal_species }
      else
        format.html { render action: 'new' }
        format.json { render json: @animal_species.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animal_species/1
  # PATCH/PUT /animal_species/1.json
  def update
    respond_to do |format|
      if @animal_species.update(animal_species_params)
        format.html { redirect_to @animal_species, notice: 'Animal species was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @animal_species.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animal_species/1
  # DELETE /animal_species/1.json
  def destroy
    @animal_species.destroy
    respond_to do |format|
      format.html { redirect_to animal_species_index_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal_species
      @animal_species = AnimalSpecies.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def animal_species_params
      params.require(:animal_species).permit(:common_name, :species)
    end
end
