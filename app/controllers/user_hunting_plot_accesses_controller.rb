class UserHuntingPlotAccessesController < ApplicationController
  before_action :set_user_hunting_plot_access, only: [:show, :edit, :update, :destroy]

  # GET /user_hunting_plot_accesses
  # GET /user_hunting_plot_accesses.json
  def index
    @user_hunting_plot_accesses = UserHuntingPlotAccess.all
  end

  # GET /user_hunting_plot_accesses/1
  # GET /user_hunting_plot_accesses/1.json
  def show
  end

  # GET /user_hunting_plot_accesses/new
  def new
    @user_hunting_plot_access = UserHuntingPlotAccess.new
  end

  # GET /user_hunting_plot_accesses/1/edit
  def edit
  end

  # POST /user_hunting_plot_accesses
  # POST /user_hunting_plot_accesses.json
  def create
    @user_hunting_plot_access = UserHuntingPlotAccess.new(user_hunting_plot_access_params)

    respond_to do |format|
      if @user_hunting_plot_access.save
        format.html { redirect_to @user_hunting_plot_access, notice: 'User hunting plot access was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_hunting_plot_access }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_hunting_plot_access.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_hunting_plot_accesses/1
  # PATCH/PUT /user_hunting_plot_accesses/1.json
  def update
    respond_to do |format|
      if @user_hunting_plot_access.update(user_hunting_plot_access_params)
        format.html { redirect_to @user_hunting_plot_access, notice: 'User hunting plot access was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_hunting_plot_access.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_hunting_plot_accesses/1
  # DELETE /user_hunting_plot_accesses/1.json
  def destroy
    @user_hunting_plot_access.destroy
    respond_to do |format|
      format.html { redirect_to user_hunting_plot_accesses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_hunting_plot_access
      @user_hunting_plot_access = UserHuntingPlotAccess.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_hunting_plot_access_params
      params.require(:user_hunting_plot_access).permit(:users_id, :hunting_plots_id, :alias, :permissions)
    end
end
