class CalanderMailer < ApplicationMailer

  def send_creation_notification
    subject = "Calander Event Created"
    @to = params[:user]
    @resource = params[:calander]
    mail(to: @to.email, subject: subject)
  end

end
