class CompositeNetworkMembersController < ApplicationController

  before_action :set_composite_network_member, only: [:show, :edit, :update, :destroy, :delete]
  before_action :set_user_network, only: [:create, :new, :show, :edit, :update, :index]

  include CompositeNetworkMembersControllerExtensions

  # GET /composite_network_members
  def index
    @composite_network_members = CompositeNetworkMember.all
  end

  # GET /composite_network_members/1
  def show
  end

  # GET /composite_network_members/new
  def new
    @composite_network_member = CompositeNetworkMember.new
    @composite_network_member.composite_network_id = @user_network.id
    @composite_network_member.init_new current_user
  end

  # GET /composite_network_members/1/edit
  def edit
  end

  # POST /composite_network_members
  def create
    @composite_network_member = CompositeNetworkMember.new(composite_network_member_create_params)
    @composite_network_member.composite_network_id = @user_network.id
    @composite_network_member.init_new current_user

    respond_to do |format|
      if @composite_network_member.save
        format.html {
          flash[:success] = 'Composite network member was successfully created.'
          redirect_to @composite_network_member
        }
        format.json { render action: 'show', status: :created, location: @composite_network_member }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @composite_network_member.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /composite_network_members/1
  def update
    respond_to do |format|
      if @composite_network_member.update(composite_network_member_update_params)
        format.html {
          flash[:success] = 'Composite network member was successfully updated.'
          redirect_to @composite_network_member
        }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @composite_network_member.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /composite_network_members/1
  def destroy
    @composite_network_member.destroy
    respond_to do |format|
      format.html { redirect_to composite_network_members_url, notice: 'Composite network member was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_composite_network_member
      @composite_network_member = CompositeNetworkMember.find(params[:id])
    end

    def set_user_network
      if @composite_network_member.nil?
        @user_network = UserNetwork.find(params[:user_network_id])
      else
        @user_network = @composite_network_member.composite_network
      end
    end

    def composite_network_member_update_params
      params.require(:composite_network_member).permit(:member_network_id)
    end

    def composite_network_member_create_params
      params.require(:composite_network_member).permit(:member_network_id)
    end

end
