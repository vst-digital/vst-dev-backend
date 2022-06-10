class UserStorageAccess < ApplicationRecord
  belongs_to :user_storage
  belongs_to :user_storage_access_data, foreign_key: :user_storage_id, class_name: 'UserStorage' 
  belongs_to :shared_with, foreign_key: :shared_with_id, class_name: 'User'
  belongs_to :shared_by, foreign_key: :shared_by_id, class_name: 'User'
  validates_uniqueness_of :user_storage_id, scope: [:project_id, :shared_with_id, :shared_by_id ]
end
