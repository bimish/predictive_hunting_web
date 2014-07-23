class UserNetworksController < ApplicationController

  before_action :set_user_network, only: [:show, :edit, :update, :destroy, :delete]

  include UserNetworksControllerExtensions

  # GET /user_networks
  def index
    @user_networks = UserNetwork.all
  end

  # GET /user_networks/1
  def show
  end

  # GET /user_networks/new
  def new
    @user_network = UserNetwork.new
    @user_network.init_new current_user
  end

  # GET /user_networks/1/edit
  def edit
  end

  # POST /user_networks
  def create
    @user_network = UserNetwork.new(user_network_create_params)
    @user_network.init_new current_user

    respond_to do |format|
      if @user_network.save
        format.html { redirect_to @user_network, notice: 'User network was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_network }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_network.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /user_networks/1
  def update
    respond_to do |format|
      if @user_network.update(user_network_update_params)
        format.html { redirect_to @user_network, notice: 'User network was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_network.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /user_networks/1
  def destroy
    @user_network.destroy
    respond_to do |format|
      format.html { redirect_to user_networks_url, notice: 'User network was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_network
      @user_network = UserNetwork.find(params[:id])
    end

    def user_network_update_params
      params.require(:user_network).permit(:name, :network_type)
    end

    def user_network_create_params
      params.require(:user_network).permit(:name, :network_type)
    end

end
