class HuntingPlotNamedAnimalsController < ApplicationController

  before_action :set_hunting_plot_named_animal, only: [:show, :edit, :update, :destroy, :delete]
  before_action :set_hunting_plot

  include HuntingPlotNamedAnimalsControllerExtensions

  # GET /hunting_plot_named_animals
  def index
    @hunting_plot_named_animals = @hunting_plot.named_animals
  end

  # GET /hunting_plot_named_animals/1
  def show
  end

  # GET /hunting_plot_named_animals/new
  def new
    @hunting_plot_named_animal = HuntingPlotNamedAnimal.new
    @hunting_plot_named_animal.hunting_plot_id = @hunting_plot.id
    @hunting_plot_named_animal.init_new current_user
  end

  # GET /hunting_plot_named_animals/1/edit
  def edit
  end

  # POST /hunting_plot_named_animals
  def create
    @hunting_plot_named_animal = HuntingPlotNamedAnimal.new(hunting_plot_named_animal_create_params)
    @hunting_plot_named_animal.hunting_plot_id = @hunting_plot.id
    @hunting_plot_named_animal.init_new current_user

    respond_to do |format|
      if @hunting_plot_named_animal.save
        format.html {
          flash[:success] = 'Hunting plot named animal was successfully created.'
          redirect_to @hunting_plot_named_animal
        }
        format.json { render action: 'show', status: :created, location: @hunting_plot_named_animal }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @hunting_plot_named_animal.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /hunting_plot_named_animals/1
  def update
    respond_to do |format|
      if @hunting_plot_named_animal.update(hunting_plot_named_animal_update_params)
        format.html {
          flash[:success] = 'Hunting plot named animal was successfully updated.'
          redirect_to @hunting_plot_named_animal
        }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @hunting_plot_named_animal.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /hunting_plot_named_animals/1
  def destroy
    @hunting_plot_named_animal.destroy
    respond_to do |format|
      format.html { redirect_to hunting_plot_named_animals_url, notice: 'Hunting plot named animal was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hunting_plot_named_animal
      @hunting_plot_named_animal = HuntingPlotNamedAnimal.find(params[:id])
    end

    def set_hunting_plot
      if @hunting_plot_named_animal.nil?
        @hunting_plot = HuntingPlot.find(params[:hunting_plot_id])
      else
        @hunting_plot = @hunting_plot_named_animal.hunting_plot
      end
    end

    def hunting_plot_named_animal_update_params
      params.require(:hunting_plot_named_animal).permit(:hunting_plot_id, :name, :animal_category_id)
    end

    def hunting_plot_named_animal_create_params
      params.require(:hunting_plot_named_animal).permit(:hunting_plot_id, :name, :animal_category_id)
    end

end
