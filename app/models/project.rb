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

  enum status: [:draft, :active, :completed, :closed]

  def get_user_storage(user)
    result = user_storages.present? ? user_storages : []
    # if result.blank?
    #   result = user_storages.create(user: user, name: 'default', isDirectory: true)
    # end
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
    if result
      return result.select{|a| a.parent_id.blank?}
    end
    result
  end 

end