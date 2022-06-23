class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  #site_member, will create organization for the subscription_owner
  #subscription_owner, will be able to create the project and can assign the project to a member
  enum role: [:site_owner,:site_member, :subscription_owner, :project_admin, :project_member]
  # has_many :organizations
  # has_many :project_members
  has_many :projects
  has_many :user_storages
  has_many :invitations, class_name: 'User', as: :invited_by
  has_many :created_groups, foreign_key: :user_id, class_name: 'Group'
  has_many :group_members
  has_many :groups, through: :group_members, class_name: :Group, as: :assigned_groups
  has_many :user_storage_accesses, foreign_key: 'shared_by_id' do 
    def by_project(project)
      where(project_id: project)
    end
  end

  has_many :calanders do 
    def by_project(project)
      where(project_id: project)
    end 
  end
  
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  # after_create :create_default_organization, if: Proc.new { |user| user.subscription_owner? &&  user.organizations.blank? }

  def jwt_payload
    { 'initials' => "#{first_name.first}#{last_name.first}", 'user_name' =>  first_name, 'user' => role, 'contact' => contact}
  end

  def create_default_organization
    organizations.create( name: "Default Name", phone: "0987654321", address: "Default address" )
  end 
  
  def site_owner?
    self.email == "togulsharan@gmail.com"
  end

  def all_groups
    result = []
    all_groups  = (groups + created_groups).uniq
    if all_groups 
      result = Group.where(id: all_groups.uniq.map(&:id))
    end
    return result
  end



  # def org_projects
  #   result = []
  #   if organizations
  #     result = organizations.try(:first).try(:projects)
  #   end
  #   return result
  # end

  # def all_projects
  #   result = []
  #   group_projects = all_groups.map(&:projects)
  #   if group_projects.try(:flatten).present? || org_projects.present?
  #     if org_projects.present? && group_projects.try(:flatten).present?
  #       all_projects = (group_projects + org_projects).uniq
  #       result = Project.where(id: all_projects.flatten.map(&:id))
  #     elsif !org_projects.present? && group_projects.try(:flatten).present?
  #       result = Project.where(id: group_projects.flatten.map(&:id))
  #     elsif org_projects.present? && !group_projects.try(:flatten).present?
  #       result = Project.where(id: org_projects.flatten.map(&:id))
  #     end
  #   end
  #   return result
  # end

  def all_projects
    if !projects.blank?
      projects
    else
      Project.where(id: groups.map(&:project_id))
    end 
  end 

end