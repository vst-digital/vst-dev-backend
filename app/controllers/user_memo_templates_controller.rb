class UserMemoTemplatesController < ApplicationController
  include ApiResponse
  before_action :set_user_memo_template, only: %i[ show update destroy ]
  before_action :current_project, only: %i[ show update destroy index create ]

  # GET /user_memo_templates
  def index
    per_page_value = 10
    pagination = generate_pagination(current_project.user_memo_templates.page(params[:page_no]).per(per_page_value))
    json_response(current_project.user_memo_templates, :ok, UserMemoTemplateSerializer, pagination)
  end

  # GET /user_memo_templates/1
  def show
    json_response(@user_memo_template, :ok, UserMemoTemplateSerializer, pagination ={})
  end

  # POST /user_memo_templates
  def create
    if params["memo_template"]["json"]
      user_memo_template = @project.user_memo_templates.new()
      user_memo_template.template = params["memo_template"]["json"]
      user_memo_template.project_id = @project.id
      user_memo_template.user_id = current_user.id
      if user_memo_template.save
        render json: @user_memo_template, status: :created, location: @user_memo_template
      else
        render json: @user_memo_template.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /user_memo_templates/1
  def update
    if @user_memo_template.update(user_memo_template_params)
      render json: @user_memo_template
    else
      render json: @user_memo_template.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_memo_templates/1
  def destroy
    @user_memo_template.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_memo_template
      @user_memo_template = UserMemoTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_memo_template_params
      params.require(:memo_template).permit(:id, :number, :name, :template, :memo_text)
    end

    def current_project
      @project = current_user.projects.find_by(id: request.headers['Project'].to_i)
      if @project.blank?
        current_user.groups
        @project = Project.find_by(id: current_user.groups.map{|a| a.project.id}) 
      end
    end
end
