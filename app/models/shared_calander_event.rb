class SharedCalanderEvent < ApplicationRecord
  belongs_to :user
  belongs_to :calander
  belongs_to :shared_with, foreign_key: "shared_with_id", class_name: "User"
end
