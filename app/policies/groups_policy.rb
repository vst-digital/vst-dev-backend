class GroupPolicy 
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def upgrade?
    @user.site_owner? || @user.subscription_owner? || @user.project_admin?
  end

  def show?
    true
  end

  def create?
    @user.site_owner? || @user.subscription_owner? || @user.project_admin?
  end

  def update?
    @user.site_owner? || @user.subscription_owner? || @user.project_admin?
  end

  def destroy?
    false
  end

end 