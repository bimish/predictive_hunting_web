module MailHelper

  def self.user_invite_email(user_invitation, hunting_plot_access_request = nil)
    sender_name = "#{user_invitation.created_by_user.first_name} #{user_invitation.created_by_user.last_name}"
    if (hunting_plot_access_request.nil?)
      UserMailer.user_invite(user_invitation.id, user_invitation.email, sender_name).deliver
    else
      UserMailer.user_invite_with_plot(user_invitation.id, user_invitation.email, sender_name, hunting_plot_access_request.hunting_plot.name).deliver
    end
  end

  def self.plot_invite_email(hunting_plot_access_request)
    recipient_email = hunting_plot_access_request.user_id.nil? ? hunting_plot_access_request.user_invitation.email : hunting_plot_access_request.user.email
    sender_name = "#{hunting_plot_access_request.created_by_user.first_name} #{hunting_plot_access_request.created_by_user.last_name}"
    UserMailer.plot_invite(hunting_plot_access_request.id, recipient_email, sender_name, hunting_plot_access_request.hunting_plot.name).deliver
  end

  def self.password_reset_email(user)
    UserMailer.password_reset(user.email, user.password_reset_token).deliver
  end

end
