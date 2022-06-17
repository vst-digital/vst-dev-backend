class MailerJob < ApplicationJob
  queue_as :mailer

  def perform(data, current_user, project, group_id)
    response = User.invite!(data, current_user)
    project.groups.find_by(id: group_id).users << response if response.id.present?
    print(">>>>>>>>>>Invitation sent<<<<<<<<<<<<<")
  end
end
