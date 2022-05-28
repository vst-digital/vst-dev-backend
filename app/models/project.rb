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

  def get_user_storage(user)
    result = UserStorage.find_by(user: user, project: self)
    if result.blank?
      result = UserStorage.create(user: user, project: self, name: 'default')
    end
    result
  end

  def get_storage_data(user)
    get_user_storage(user).try(:storage_data)
  end 

  def get_storage_child_data(user, parent_id)
    result = get_storage_data(user)
    if result
      return result.select{|a| a.parent_id == parent_id}
    end
    result
  end 

  def get_storage_parent_data(user)
    result = get_storage_data(user)
    if result
      return result.select{|a| a.parent_id.blank?}
    end
    result
  end 

end