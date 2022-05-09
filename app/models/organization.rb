class Organization < ApplicationRecord
    belongs_to :user
    # has_many :members
    # validate :exsisting_organization, on: :create
    validates :name, presence: true
    # has_many :projects

    # def exsisting_organization
    #     get_current_user.organization.present?
    # end 
end
