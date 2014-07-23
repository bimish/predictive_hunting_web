class FriendRequestsController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  before_action :set_relationship_request, only: [:show, :edit, :update, :destroy, :delete, :accept, :reject ]
  before_action :authorize_action, only: [:show, :edit, :update, :destroy, :delete ]

  # GET /friend_requests
  def index
    @existing_requests = RelationshipRequest.where(related_user_id: current_user.id, status: RelationshipRequest.statuses[:status_new])
  end

  # GET /friend_requests/1
  def show
  end

  # GET /friend_requests/new
  def new
    @user_relationship = UserRelationship.new
    @user_relationship.init_new current_user
    @existing_requests = RelationshipRequest.where(created_by_id: current_user.id)
  end

  # PATCH /friend_requests/1/accept
  def accept
    raise Exceptions::NotAuthorized unless @relationship_request.authorize_action?(current_user, :update)
    @relationship_request.accept
    render action: 'show'
  end

  # PATCH /friend_requests/1/reject
  def reject
    raise Exceptions::NotAuthorized unless @relationship_request.authorize_action?(current_user, :update)
    if @relationship_request.update(status: RelationshipRequest.statuses[:status_rejected])
      render action: 'show'
    else
      render json: @relationship_request, status: :unprocessable_entity
    end
  end

  # GET /friend_requests/1/edit
  def edit
  end

  # POST /friend_requests
  def create
    @user_relationship = UserRelationship.new(user_relationship_create_params)
    @user_relationship.init_new current_user

    respond_to do |format|
      if @user_relationship.save
        format.html { redirect_to @user_relationship, notice: 'User relationship was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_relationship }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_relationship.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /friend_requests/1
  def update
    respond_to do |format|
      if @user_relationship.update(user_relationship_update_params)
        format.html { redirect_to @user_relationship, notice: 'User relationship was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_relationship.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /friend_requests/1
  def destroy
    @user_relationship.destroy
    respond_to do |format|
      format.html { redirect_to user_relationships_url, notice: 'User relationship was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relationship_request
      @relationship_request = RelationshipRequest.find(params[:id])
    end

    def user_relationship_update_params
      params.require(:user_relationship).permit(:relationship_type)
    end

    def user_relationship_create_params
      params.require(:user_relationship).permit(:related_user_id, :relationship_type)
    end

    def authorize_action
      raise Exceptions::NotAuthorized unless @relationship_request.authorize_action?(current_user, params[:action].to_sym)
    end

end
