class ProjectUserMemo < ApplicationRecord
  belongs_to :project
  belongs_to :user
  # belongs_to :memo_id
end