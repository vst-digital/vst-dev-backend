class Calander < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :shared_calander_events
  accepts_nested_attributes_for :shared_calander_events , allow_destroy: true, reject_if: proc{|attribute|}

  validates :end_date, comparison: { greater_than_or_equal_to: :start_date}

  # after_create :send_notification

  def send_notification
    CalanderMailer.with(user: user, calander: self).send_creation_notification.deliver_later
  end

end
