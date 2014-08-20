class HuntingPlotNamedAnimalsController < ComponentController

  include HuntingPlotNamedAnimalsControllerExtensions

  # GET /hunting_plot_named_animals
  def index
    @hunting_plot_named_animals ||= HuntingPlotNamedAnimal.all
  end

  # GET /hunting_plot_named_animals/1
  def show
  end

  # GET /hunting_plot_named_animals/new
  def new
  end

  # GET /hunting_plot_named_animals/1/edit
  def edit
  end

  # POST /hunting_plot_named_animals
  def create
    respond_to do |format|
      if @hunting_plot_named_animal.save
        format.html { redirect_to @hunting_plot_named_animal, notice: 'Hunting plot named animal was successfully created.' }
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
      if @hunting_plot_named_animal.update(update_params)
        format.html { redirect_to @hunting_plot_named_animal, notice: 'Hunting plot named animal was successfully updated.' }
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
    def get_component
      @hunting_plot_named_animal = HuntingPlotNamedAnimal.find(params[:id])
    end

    def new_component(params = nil)
      @hunting_plot_named_animal = HuntingPlotNamedAnimal.new(params)
    end

    def update_params
      params.require(:hunting_plot_named_animal).permit(:name, :animal_category_id)
    end

    def create_params
      params.require(:hunting_plot_named_animal).permit(:name, :animal_category_id)
    end

end
