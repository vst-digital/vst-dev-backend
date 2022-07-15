class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  
  # has_many :organizations
  # has_many :project_members
  has_many :projects
  has_many :user_storages, -> {extending ByProjectExtension}
  has_many :invitations, -> {extending ByProjectExtension}, class_name: 'User', as: :invited_by
  has_many :created_groups, -> {extending ByProjectExtension}, foreign_key: :user_id, class_name: 'Group'
  has_many :group_members, -> {extending ByProjectExtension}
  has_many :groups, -> {extending ByProjectExtension}, through: :group_members, class_name: :Group, as: :assigned_groups
  has_many :user_storage_accesses, -> {extending ByProjectExtension}, foreign_key: 'shared_by_id'
  has_many :calanders, -> {extending ByProjectExtension}
  has_many :inspection_sheets, -> {extending ByProjectExtension}
  has_many :user_inspection_sheets, -> {extending ByProjectExtension}
  
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  #validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  
  #enums
  enum role: [:site_owner, :site_member, :subscription_owner, :project_admin, :project_member]

  def jwt_payload
    { 'initials' => "#{first_name.first}#{last_name.first}", 'user_name' =>  first_name, 'user' => role, 'contact' => contact, 'expirationTime': (Time.current + 8.hours).to_i}
  end

  # after_create :create_default_organization, if: Proc.new { |user| user.subscription_owner? &&  user.organizations.blank? }
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

  def all_projects
    if !projects.blank?
      projects
    else
      Project.where(id: groups.map(&:project_id))
    end 
  end 

end