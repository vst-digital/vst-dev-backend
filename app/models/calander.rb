class Calander < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :start_date, comparison: { greater_than_or_equal_to: :end_date}

  after_create :send_notification

  def send_notification
    CalanderMailer.with(user: user, calander: self).send_creation_notification.deliver_later
  end

end
