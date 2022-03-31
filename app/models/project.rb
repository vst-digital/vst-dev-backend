class Project < ApplicationRecord
  has_many :tasks
  has_many :project_members, dependent: :destroy
  has_many :users, through: :project_members, source: "project_id"
  belongs_to :organization
  validates :title, presence: true
  validates :project_description, presence: true
  has_many :groups

  enum status: [:draft, :active, :completed, :closed]
end
