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
  has_many :user_storages
  has_many :user_storage_accesses
  has_many :user_storage_access_data, through: :user_storage_accesses, foreign_key: :user_storage_id, class_name: "UserStorageAccess"

  enum status: [:draft, :active, :completed, :closed]

  def get_user_storage(user)
    exsisting_user_storage = user_storages.where(user_id: user.id)
    exsisting_user_storage_accesses = user_storage_accesses.where(shared_with_id: user.id)
    if exsisting_user_storage.present?
      result = exsisting_user_storage
    end
    if exsisting_user_storage_accesses.present?
      result = exsisting_user_storage_accesses.map(&:user_storage)
    end
    if exsisting_user_storage.present? && exsisting_user_storage_accesses.present?
      data_to_append = exsisting_user_storage_accesses.map(&:user_storage)
      result = (exsisting_user_storage + data_to_append).uniq
    end
    if exsisting_user_storage.blank? && exsisting_user_storage_accesses.blank?
      result = []
    end 
    result
  end

  def get_storage_child_data(user, parent_id)
    result = get_user_storage(user)
    if result
      return result.select{|a| a.parent_id == parent_id}
    end
    result
  end 

  def get_storage_parent_data(user)
    result = get_user_storage(user)
    if result.class == "Array" || result.present?
      return result.where(parent_id: nil)
    end
    result
  end 

  def get_all_members
    groups.map(&:users).try(:flatten).try(:uniq)
  end

end