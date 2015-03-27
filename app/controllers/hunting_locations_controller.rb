class HuntingLocationsController < ComponentController

  include HuntingLocationsControllerExtensions

  # GET /hunting_locations
  def index
    @hunting_locations ||= HuntingLocation.all
  end

  # GET /hunting_locations/1
  def show
  end

  # GET /hunting_locations/new
  def new
  end

  # GET /hunting_locations/1/edit
  def edit
  end

  # POST /hunting_locations
  def create
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
      if @hunting_location.update(update_params)
        format.html { redirect_to @hunting_location, notice: 'Hunting location was successfully updated.' }
        format.json { render action: 'show' }
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
    def get_component
      @hunting_location = HuntingLocation.find(params[:id])
    end

    def new_component(params = nil)
      @hunting_location = HuntingLocation.new(params)
    end

    def update_params
      params.require(:hunting_location).permit(:name, :coordinates, :location_type, :access_flags_public, :access_flags_accepts_requests)
    end

    def create_params
      params.require(:hunting_location).permit(:name, :coordinates, :location_type, :access_flags_public, :access_flags_accepts_requests)
    end

end
