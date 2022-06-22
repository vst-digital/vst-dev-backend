class Users::PasswordsController < Devise::PasswordsController
  before_action :set_user, only: [:create]
  respond_to :json
  
  def create
    resource = @user.send_reset_password_instructions
    if resource.present?
      render json: { message: 'Email sent' }, status: :ok
    else
      render json: { message: 'Something went wrong.' }, status: :unprocessable_entity
    end
  end

  private
  
  def members_params
    params.require(:user).permit(:email)
  end

  def set_user
    @user = User.find_by(email: members_params[:email])
  end


end