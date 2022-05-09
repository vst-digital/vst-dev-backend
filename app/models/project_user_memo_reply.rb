class ProjectUserMemoReply < ApplicationRecord
  belongs_to :project_user_memo
  belongs_to :created_by, foreign_key: :created_by, class_name: 'User'
end
