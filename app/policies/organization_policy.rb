class OrganizationPolicy 
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    @user.site_owner? 
  end

  def upgrade?
    @user.site_owner? || @user.subscription_owner?
  end

  def show?
    @user.site_owner? || @user.subscription_owner?
  end

  def create?
    @user.site_owner? || @user.subscription_owner?
  end

  def update?
    @user.site_owner? || @user.subscription_owner?
  end

  def destroy?
    false
  end
end 