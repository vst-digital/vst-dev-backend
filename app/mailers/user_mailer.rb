class UserMailer < ApplicationMailer
  def send_invite
    body = "You are invited to contribute."
    to = params[:user]
    @resource = params[:user]
    mail(to: to.email, subject: body)
  end
end
