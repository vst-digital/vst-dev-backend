class Group < ApplicationRecord
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members, class_name: :User
  # has_many :project_groups
  belongs_to :project
  after_create :add_admin_to_group

  def add_admin_to_group
    users << project.user if project.user.subscription_owner? || project.user.project_admin?
    self.save
  end
end
