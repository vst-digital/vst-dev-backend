class UserMailer < ApplicationMailer
  def send_invite
    body = "You are invited to contribute."
    to = params[:user]
    mail(to: to, subject: body)
  end
end
