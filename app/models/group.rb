class Group < ApplicationRecord
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members, class_name: :User
  # has_many :project_groups
  belongs_to :project
end
