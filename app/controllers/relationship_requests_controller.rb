class RelationshipRequestsController < ApplicationController

  before_action :set_relationship_request, only: [:show, :edit, :update, :destroy, :delete]

  include RelationshipRequestsControllerExtensions

  # GET /relationship_requests
  def index
    @relationship_requests = RelationshipRequest.all
  end

  # GET /relationship_requests/1
  def show
  end

  # GET /relationship_requests/new
  def new
    @relationship_request = RelationshipRequest.new
    @relationship_request.init_new current_user
  end

  # GET /relationship_requests/1/edit
  def edit
  end

  # POST /relationship_requests
  def create
    @relationship_request = RelationshipRequest.new(relationship_request_create_params)
    @relationship_request.init_new current_user

    respond_to do |format|
      if @relationship_request.save
        format.html { redirect_to @relationship_request, notice: 'Relationship request was successfully created.' }
        format.json { render action: 'show', status: :created, location: @relationship_request }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @relationship_request.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /relationship_requests/1
  def update
    respond_to do |format|
      if @relationship_request.update(relationship_request_update_params)
        format.html { redirect_to @relationship_request, notice: 'Relationship request was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @relationship_request.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /relationship_requests/1
  def destroy
    @relationship_request.destroy
    respond_to do |format|
      format.html { redirect_to relationship_requests_url, notice: 'Relationship request was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relationship_request
      @relationship_request = RelationshipRequest.find(params[:id])
    end

    def relationship_request_update_params
      params.require(:relationship_request).permit(:status)
    end

    def relationship_request_create_params
      params.require(:relationship_request).permit(:related_user_id, :status)
    end

end
