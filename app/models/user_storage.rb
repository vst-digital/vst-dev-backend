class UserStorage < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :storage_data, dependent: :destroy
  # scope :storage_data_parent, -> (storage_data) { left_joins(:storage_data).where(storage_data: {parent_id: nil}) }

  def get_items
    storage_data
  end

end
