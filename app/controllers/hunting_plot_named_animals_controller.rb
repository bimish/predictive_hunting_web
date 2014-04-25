class HuntingPlotNamedAnimalsController < ApplicationController
  before_action :set_hunting_plot_named_animal, only: [:show, :edit, :update, :destroy]

  # GET /hunting_plot_named_animals
  # GET /hunting_plot_named_animals.json
  def index
    @hunting_plot_named_animals = HuntingPlotNamedAnimal.all
  end

  # GET /hunting_plot_named_animals/1
  # GET /hunting_plot_named_animals/1.json
  def show
  end

  # GET /hunting_plot_named_animals/new
  def new
    @hunting_plot_named_animal = HuntingPlotNamedAnimal.new
  end

  # GET /hunting_plot_named_animals/1/edit
  def edit
  end

  # POST /hunting_plot_named_animals
  # POST /hunting_plot_named_animals.json
  def create
    @hunting_plot_named_animal = HuntingPlotNamedAnimal.new(hunting_plot_named_animal_params)

    respond_to do |format|
      if @hunting_plot_named_animal.save
        format.html { redirect_to @hunting_plot_named_animal, notice: 'Hunting plot named animal was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hunting_plot_named_animal }
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_plot_named_animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hunting_plot_named_animals/1
  # PATCH/PUT /hunting_plot_named_animals/1.json
  def update
    respond_to do |format|
      if @hunting_plot_named_animal.update(hunting_plot_named_animal_params)
        format.html { redirect_to @hunting_plot_named_animal, notice: 'Hunting plot named animal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hunting_plot_named_animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hunting_plot_named_animals/1
  # DELETE /hunting_plot_named_animals/1.json
  def destroy
    @hunting_plot_named_animal.destroy
    respond_to do |format|
      format.html { redirect_to hunting_plot_named_animals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hunting_plot_named_animal
      @hunting_plot_named_animal = HuntingPlotNamedAnimal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hunting_plot_named_animal_params
      params.require(:hunting_plot_named_animal).permit(:name, :animal_species_id, :animal_category_id)
    end
end
