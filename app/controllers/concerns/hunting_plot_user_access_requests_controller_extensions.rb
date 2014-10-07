module HuntingPlotUserAccessRequestsControllerExtensions

  #class ViewData
  #  def data_element
  #    @data_element ||= xyz
  #  end
  #end

  def review
    @invitations = current_user.hunting_plot_invitations
  end

  def accept
    @hunting_plot_user_access_request.accept
  end

  def decline
    @hunting_plot_user_access_request.decline
  end

  def get_crud_action
    case action_name
    when 'confirm'
      :read
    when 'accept', 'decline'
      :update
    else
      super
    end
  end

  extend ActiveSupport::Concern

  included do
    #before_action :set_view_data
    before_action :get_component, only: [:confirm, :accept, :decline]
    after_initialize_new_instance :initialize_new_instance
  end

private

  # controller assign-properties
  def initialize_new_instance

    @hunting_plot_user_access_request.hunting_plot_id = params[:hunting_plot_id]

    # resolve the user id or create a user invitation
    if (action_name == 'create')

      email_address = params[:hunting_plot_user_access_request][:invite_email]
      if email_address.blank?
        @hunting_plot_user_access_request.errors.add(:base, 'An email address must be provided')
        render action: 'new'
      else
        email_address.downcase!
        existing_user = User.find_by(email: email_address)
        if (existing_user.nil?)
          user_invitation = UserInvitation.find_by(email: email_address)
          if user_invitation.nil?
            user_invitation = UserInvitation.create(email: email_address, message: params[:message])
            user_invitation.init_new(current_user)
            user_invitation.skip_invite_email = true # defer this to the plot invitation
            if (!user_invitation.save)
              @hunting_plot_user_access_request.errors.add(:base, 'An unexpected error has occurred')
            end
          end
          unless user_invitation.nil?
            @hunting_plot_user_access_request.user_invitation_id = user_invitation.id
          end
        else
          @hunting_plot_user_access_request.user_id = existing_user.id
        end
      end

    end

  end

  #def set_view_data
  #  @view_data = ViewData.new()
  #end

end

