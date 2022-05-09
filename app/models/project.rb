class Project < ApplicationRecord
  has_many :tasks
  has_many :project_members, dependent: :destroy
  has_many :users, through: :project_members, source: "project_id"
  belongs_to :user
  validates :title, presence: true
  validates :project_description, presence: true
  has_many :groups
  has_many :user_memo_templates
  has_many :project_user_memos

  enum status: [:draft, :active, :completed, :closed]
end