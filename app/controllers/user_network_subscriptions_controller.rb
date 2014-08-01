class UserNetworkSubscriptionsController < ApplicationController

  before_action :set_user_network_subscription, only: [:show, :edit, :update, :destroy, :delete]

  include UserNetworkSubscriptionsControllerExtensions

  # GET /user_network_subscriptions
  def index
    @user_network_subscriptions = current_user.network_subscriptions.preload(:network)
  end

  # GET /user_network_subscriptions/1
  def show
  end

  # GET /user_network_subscriptions/new
  def new
    @user_network_subscription = UserNetworkSubscription.new
    @user_network_subscription.init_new current_user
  end

  # GET /user_network_subscriptions/1/edit
  def edit
  end

  # POST /user_network_subscriptions
  def create
    @user_network_subscription = UserNetworkSubscription.new(user_network_subscription_create_params)
    @user_network_subscription.init_new current_user

    respond_to do |format|
      if @user_network_subscription.save
        format.html { redirect_to @user_network_subscription, notice: 'User network subscription was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_network_subscription }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_network_subscription.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /user_network_subscriptions/1
  def update
    respond_to do |format|
      if @user_network_subscription.update(user_network_subscription_update_params)
        format.html { redirect_to @user_network_subscription, notice: 'User network subscription was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_network_subscription.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /user_network_subscriptions/1
  def destroy
    @user_network_subscription.destroy
    respond_to do |format|
      format.html { redirect_to user_network_subscriptions_url, notice: 'User network subscription was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  # GET /user_network_subscriptions/manage
  def manage
    @current_subscriptions = current_user.network_subscriptions.preload(:network)
    @top_level_networks = UserNetwork.root_level_networks
    @network_categories = UserNetworkCategory.all.map { |m| { id: m.id, name: m.name, is_composite: m.is_composite } }
  end

  # GET /user_network_subscriptions/child_networks/1
  def child_networks
    @parent_network = UserNetwork.find(params[:id])
    @child_networks = @parent_network.child_networks
  end

  # GET /user_network_subscriptions/subscribe?network_id
  def add_subscription
    # TODO: proper error handling
    @user_network_subscription = UserNetworkSubscription.new(user_network_id: params[:network_id])
    @user_network_subscription.init_new current_user
    @user_network_subscription.save
    @current_subscriptions = current_user.network_subscriptions.preload(:network)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_network_subscription
      @user_network_subscription = UserNetworkSubscription.find(params[:id])
    end

    def user_network_subscription_update_params
      params.require(:user_network_subscription).permit(:user_network_id)
    end

    def user_network_subscription_create_params
      params.require(:user_network_subscription).permit(:user_network_id)
    end

end
