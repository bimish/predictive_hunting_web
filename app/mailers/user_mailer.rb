class UserMailer < ActionMailer::Base

  def user_invite(invite_id, email_address, invite_from)
    @invite_id = invite_id
    @email_address = email_address
    @invite_from = invite_from
    mail(to: email_address, subject: "Invitation from #{invite_from} to join Predictive Hunting Application")
  end

  def user_invite_with_plot(invite_id, email_address, invite_from, plot_name)
    @invite_id = invite_id
    @email_address = email_address
    @invite_from = invite_from
    @plot_name = plot_name
    mail(to: email_address, subject: "Invitation from #{invite_from} to join Predictive Hunting Application")
  end

  def plot_invite(invite_id, email_address, invite_from, plot_name)
    @invite_id = invite_id
    @email_address = email_address
    @invite_from = invite_from
    @plot_name = plot_name
    mail(to: email_address, subject: "Invitation to join hunting plot #{plot_name}")
  end

  def password_reset(email_address, reset_token)
    @reset_token = reset_token
    mail(to: email_address, subject: "Password Reset")
  end

end
