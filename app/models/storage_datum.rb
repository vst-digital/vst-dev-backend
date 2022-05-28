class StorageDatum < ApplicationRecord
  acts_as_tree order: "name"
  belongs_to :user_storage
  # has_many :children, foreign_key: :parent_id, class_name: 'StorageDatum'

  has_many_attached :files do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  def get_siblings
    user_storage.storage_data.where(parent_id: parent_id)
  end

  def is_parent
    parent_id.blank?
  end
end
