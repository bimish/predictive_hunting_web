class UserNetworkBoundariesController < ApplicationController

  before_action :set_user_network_boundary, only: [:show, :edit, :update, :destroy, :delete]

  include UserNetworkBoundariesControllerExtensions

  # GET /user_network_boundaries
  def index
    @user_network_boundaries = UserNetworkBoundary.all
  end

  # GET /user_network_boundaries/1
  def show
  end

  # GET /user_network_boundaries/new
  def new
    @user_network_boundary = UserNetworkBoundary.new
    @user_network_boundary.init_new current_user
  end

  # GET /user_network_boundaries/1/edit
  def edit
  end

  # POST /user_network_boundaries
  def create
    @user_network_boundary = UserNetworkBoundary.new(user_network_boundary_create_params)
    @user_network_boundary.init_new current_user

    respond_to do |format|
      if @user_network_boundary.save
        format.html { redirect_to @user_network_boundary, notice: 'User network boundary was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_network_boundary }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_network_boundary.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /user_network_boundaries/1
  def update
    respond_to do |format|
      if @user_network_boundary.update(user_network_boundary_update_params)
        format.html { redirect_to @user_network_boundary, notice: 'User network boundary was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_network_boundary.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /user_network_boundaries/1
  def destroy
    @user_network_boundary.destroy
    respond_to do |format|
      format.html { redirect_to user_network_boundaries_url, notice: 'User network boundary was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_network_boundary
      @user_network_boundary = UserNetworkBoundary.find(params[:id])
    end

    def user_network_boundary_update_params
      params.require(:user_network_boundary).permit(:user_network_id, :boundary)
    end

    def user_network_boundary_create_params
      params.require(:user_network_boundary).permit(:user_network_id, :boundary)
    end

end
