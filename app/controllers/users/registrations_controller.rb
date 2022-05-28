# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
    before_action :set_user, only: [:update]
    respond_to :json

    def update
      if @user.update(update_params)
        render json: {
          message: 'User updated',
        }, status: :ok
      end
    end

  
    private
  
    def respond_with(resource, _opts = {})
      register_success && return if resource.persisted?
  
      register_failed
    end
  
    def register_success
      render json: {
        message: 'Signed up sucessfully.',
        user: current_user
      }, status: :ok
    end
  
    def register_failed
      render json: { message: 'Something went wrong.' }, status: :unprocessable_entity
    end

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role, :contact)
    end

    def update_params
      params.require(:user).permit(:id, :email, :password, :password_confirmation, :first_name, :last_name, :role, :contact, :avatar)
    end 

    def set_user
      @user = User.find_by(id: params[:user][:id])
    end

end