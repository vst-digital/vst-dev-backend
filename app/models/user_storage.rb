class UserStorage < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many_attached :uploads
  acts_as_tree order: "name"
end
