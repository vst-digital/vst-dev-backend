# app/controllers/members_controller.rb
class MembersController < ApplicationController
    
    include ApiResponse
    before_action :current_project, only: %i[ get_group_member index create ]
  
    def index
      per_page_value = 50
      pagination = generate_pagination(@project.groups.page(params[:page_no] || 1).per(per_page_value))
      json_response(@project.get_all_members, :ok, UserSerializer, pagination)
    end

    def get_group_member
      all_members = @project.get_all_members - [current_user]
      json_response(all_members, :ok, UserSerializer, pagination={})
    end 

    def show
      user = get_user_from_token
      render json: {
        message: "If you see this, you're in!",
        user: user
      }
    end

    def create
      data = { email: members_params["email"], role: members_params["role"], first_name: members_params["first_name"], last_name: members_params["last_name"], contact:  members_params["contact"]}
      response = MailerJob.set(queue: :mailer).perform_later(data, current_user, @project, params[:member][:group][:id])
      per_page_value = 50
      pagination = generate_pagination(current_user.invitations.page(1).per(per_page_value))
      json_response(current_user.invitations, :ok, UserSerializer, pagination)
      # if response 
      #   @project.groups.find_by(id: params[:member][:group][:id]).users << response
      #   per_page_value = 10
      #   pagination = generate_pagination(current_user.invitations.page(1).per(per_page_value))
      #   json_response(current_user.invitations, :ok, UserSerializer, pagination)
      # else
      #   render json: { message: 'Hmm nothing happened.' }, status: 500
      # end 
    end

    def accept_invitation
      if User.accept_invitation!(invitation_token: members_params[:invitation_token], password: members_params[:password])
        render json: { message: 'Invitation Accepted.' }, status: :ok
      end
    end
  
    private

    def members_params
      params.require(:member).permit(:email, :invitation_token, :password, :first_name, :last_name, :role, :id, :contact)
    end
  
    def get_user_from_token
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                               Rails.application.credentials.devise[:jwt_secret_key]).first
      user_id = jwt_payload['sub']
      User.find(user_id.to_s)
    end

    def current_project
      if current_user.project_member?
        @project = Project.where(id: current_user.groups.map(&:project).map(&:id)).first
      else
        @project = current_user.all_projects.find(request.headers['Project'].to_i)
      end
    end

end