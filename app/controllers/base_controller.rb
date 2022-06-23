class BaseController < ApplicationController
  include ApiResponse
  include ApiExceptionHandler

  before_action :verify_project
  before_action :current_project

  def per_page_value
    params[:per_page] ? params[:per_page].to_i : 50
  end

  def page_no
    params[:page_no] || 1
  end

  def send_data(pagination_data, data_to_send, serializer)
    pagination = generate_pagination(pagination_data.page(page_no).per(per_page_value))
    json_response(data_to_send, :ok, serializer, pagination)  
  end

  

  private

  def current_project
    @project = current_user.projects.find_by(id: request.headers['Project'].to_i)
      if @project.blank?
        current_user.groups
        @project = Project.find_by(id: current_user.groups.map{|a| a.project.id}) 
      end
  end

  def verify_project
    render json: {error: 'Invalid user'}, status: 401 && return if current_project.blank?
  end
end
