class ProjectUserMemo < ApplicationRecord
  belongs_to :project
  # belongs_to :user
  # belongs_to :memo_id
  has_many :project_user_memo_replies
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'

  def self.get_all_sent_memos(project, user)
    ProjectUserMemo.where(sender_id: user.id, project_id: project.id)
  end

  def self.get_all_recieved_memos(project, user)
    ProjectUserMemo.where(receiver_id: user.id, project_id: project.id)
  end

  def self.get_all_memos(project, user)
    (ProjectUserMemo.get_all_sent_memos(project, user) + ProjectUserMemo.get_all_recieved_memos(project, user)).uniq
  end
end