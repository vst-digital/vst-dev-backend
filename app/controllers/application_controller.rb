class ApplicationController < ActionController::API
    before_action :authenticate_user!, unless: :public_endpoint?
    # around_action :set_current_user
    include Pundit::Authorization
    # before_action :current_project, only: %i[ show index update destroy ]

    def set_current_user
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.jwt_secret_key).first
        user_id = jwt_payload['sub']
        User.find(user_id.to_s)
    end

    protected 

    def public_endpoint?
        public_endpoints = [
          { controller: 'members', action: 'accept_invitation' },
        ]
        public_endpoints.map{ |endpoint| endpoint[:controller] == controller_name && endpoint[:action] == action_name }.include?(true)
      end

end
