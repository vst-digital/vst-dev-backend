# app/controllers/members_controller.rb
class MembersController < ApplicationController
    include ApiResponse
    before_action :authenticate_user!
  
    def index
      per_page_value = 10
      pagination = generate_pagination(current_user.invitations.page(1).per(per_page_value))
      json_response(current_user.invitations, :ok, UserSerializer, pagination)
    end


    def show
      user = get_user_from_token
      render json: {
        message: "If you see this, you're in!",
        user: user
      }
    end

    def create
      response = User.invite!({ email: members_params["email"], role: members_params["role"], name: members_params["name"] }, current_user)
      if response 
        per_page_value = 10
        pagination = generate_pagination(current_user.invitations.page(1).per(per_page_value))
        json_response(current_user.invitations, :ok, UserSerializer, pagination)
      else
        render json: { message: 'Hmm nothing happened.' }, status: 500
      end 
    end

    def accept_invitation
      if User.accept_invitation!(invitation_token: members_params[:invitation_token], password: members_params[:password])
        render json: { message: 'Invitation Accepted.' }, status: :ok
      end
    end
  
    private

    def members_params
      params.require(:member).permit(:email, :invitation_token, :password, :name, :role, :id)
    end
  
    def get_user_from_token
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                               Rails.application.credentials.devise[:jwt_secret_key]).first
      user_id = jwt_payload['sub']
      User.find(user_id.to_s)
    end

end