class AnimalCategoriesController < ApplicationController
  before_action :set_animal_category, only: [:show, :edit, :update, :destroy]

  # GET /animal_categories
  # GET /animal_categories.json
  def index
    @animal_categories = AnimalCategory.all
  end

  # GET /animal_categories/1
  # GET /animal_categories/1.json
  def show
  end

  # GET /animal_categories/new
  def new
    @animal_category = AnimalCategory.new
  end

  # GET /animal_categories/1/edit
  def edit
  end

  # POST /animal_categories
  # POST /animal_categories.json
  def create
    @animal_category = AnimalCategory.new(animal_category_params)

    respond_to do |format|
      if @animal_category.save
        format.html { redirect_to @animal_category, notice: 'Animal category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @animal_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @animal_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animal_categories/1
  # PATCH/PUT /animal_categories/1.json
  def update
    respond_to do |format|
      if @animal_category.update(animal_category_params)
        format.html { redirect_to @animal_category, notice: 'Animal category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @animal_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animal_categories/1
  # DELETE /animal_categories/1.json
  def destroy
    @animal_category.destroy
    respond_to do |format|
      format.html { redirect_to animal_categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal_category
      @animal_category = AnimalCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def animal_category_params
      params.require(:animal_category).permit(:animal_species_id, :name, :gender, :maturity, :trophy_rating)
    end
end
