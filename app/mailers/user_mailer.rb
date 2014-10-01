class UserMailer < ActionMailer::Base

  default from: "mjshutt@gmail.com"

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

end
